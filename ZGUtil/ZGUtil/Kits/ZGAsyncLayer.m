//
//  ZGAsyncLayer.m
//  LTDemo
//
//  Created by 刘涛 on 2022/9/29.
//

#import "ZGAsyncLayer.h"
#import "ZGSentinel.h"

#if __has_include("ZGDispatchQueuePool.h")
#import "ZGDispatchQueuePool.h"
#else
#import <libkern/OSAtomic.h>
#endif

static dispatch_queue_t ZGAsyncLayerGetDisplayQueue() {
#ifdef ZGDispatchQueuePool_h
    return ZGDispatchQueueGetForQOS(NSQualityOfServiceUserInitiated);
#else
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        for (int i=0; i<queueCount; i++) {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.lt.zgutil.render", attr);
            } else {
                queues[i] = dispatch_queue_create("com.lt.zgutil.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) {
        cur = -cur;
    }
    return queues[cur % queueCount];
#endif
}

static dispatch_queue_t ZGAsyncLayerGetReleaseQueue() {
#ifdef ZGDispatchQueuePool_h
    return ZGDispatchQueueGetForQOS(NSQualityOfServiceDefault);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
#endif
}

@implementation ZGAsyncLayerDisplayTask

@end

@implementation ZGAsyncLayer {
    ZGSentinel *_sentinel;
}

+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"displayAsynchronously"]) {
        return @(YES);
    }
    return [super defaultValueForKey:key];
}

- (instancetype)init {
    self = [super init];
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    _sentinel = 0;
    _displayAsynchronously = YES;
    return self;
}

- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display {
    super.contents = super.contents;
//    [self _]
}


#pragma mark - Private
- (void)_displayAsync:(BOOL)async {
    id<ZGAsyncLayerDelegate> delegate = (id)self.delegate;
    ZGAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    if (!task.display) {
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        self.contents = nil;
        if (task.didDisplay) {
            task.didDisplay(self, YES);
        }
        return;
    }
    
    if (async) {
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        int32_t value = _sentinel.value;
        ZGSentinel *sentinel = _sentinel;
        BOOL (^isCancelled)(void) = ^BOOL() {
            return value != sentinel.value;
        };
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
//        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        //LTTODO:
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? self.backgroundColor : NULL;
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)self.contents;
            self.contents = nil;
            if (image) {
                dispatch_async(ZGAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay) {
                task.didDisplay(self, YES);
            }
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(ZGAsyncLayerGetDisplayQueue(), ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque && context) {
                CGContextSaveGState(context); {
                    if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                        CGContextFillPath(context);
                    }
                    if (backgroundColor) {
                        CGContextSetFillColorWithColor(context, backgroundColor);
                        CGContextAddRect(context, CGRectMake(0, 0, size.width*scale, size.height*scale));
                        CGContextFillPath(context);
                    }
                } CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            task.display(context, size, isCancelled);
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO);
                    }
                });
                return;
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO);
                    }
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplay) {
                        task.didDisplay(self, NO);
                    }
                } else {
                    self.contents = (__bridge  id)image.CGImage;
                    if (task.didDisplay) {
                        task.didDisplay(self, YES);
                    }
                }
            });
        });
        
    } else {
        [_sentinel increase];
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.opaque && context) {
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                }
            } CGContextRestoreGState(context);
        }
        task.display(context, self.bounds.size, ^{return NO;});
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge  id)image.CGImage;
        if (task.display) {
            task.didDisplay(self, YES);
        }
    }
}

- (void)_cancelAsyncDisplay {
    [_sentinel increase];
}


- (void)dealloc {
    [_sentinel increase];
}

@end


