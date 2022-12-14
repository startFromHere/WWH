//
//  ZGDispatchQueuePool.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/27.
//

#import "ZGDispatchQueuePool.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>
#import <stdatomic.h>

#define MAX_QUEUE_COUNT 32

static inline dispatch_queue_priority_t NSQualityOfServiceToDispatchPriority(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUserInitiated: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUtility: return DISPATCH_QUEUE_PRIORITY_LOW;
        case NSQualityOfServiceBackground: return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        default: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        default: return QOS_CLASS_DEFAULT;
    }
}

typedef struct {
    const char *name;
    void **queues;
    uint32_t queueCount;
    int32_t counter;
} ZGDispatchContext;

static ZGDispatchContext *ZGDispatchContextCreate(const char *name,
                                                  uint32_t queueCount,
                                                  NSQualityOfService qos) {
    ZGDispatchContext *context = calloc(1, sizeof(ZGDispatchContext));
    if (!context) {
        return NULL;
    }
    context->queues = calloc(queueCount, sizeof(void *));
    if (!context->queues) {
        free(context);
        return NULL;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
            dispatch_queue_t queue = dispatch_queue_create(name, attr);
            context->queues[i] = (__bridge_retained  void *)(queue);
        }
    } else {
        long identifier = NSQualityOfServiceToDispatchPriority(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_t queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(identifier, 0));
            context->queues[i] = (__bridge_retained  void *)(queue);
        }
    }
    
    context->queueCount = queueCount;
    if (name) {
        context->name = strdup(name);
    }
    
    return context;
}

static void ZGDispatchContextRelease(ZGDispatchContext *context) {
    if (!context) {
        return;
    }
    if (context->queues) {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void *queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char *name = dispatch_queue_get_label(queue);
            if (name) {
//                strlen(name);//
            }
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    if (context->name) {
        free((void *)context->name);
    }
}

static dispatch_queue_t ZGDispatchContextGetQueue(ZGDispatchContext *context) {
    uint32_t counter = (uint32_t)OSAtomicIncrement32(&context->counter);
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)queue;
}

static ZGDispatchContext *ZGDispatchContextGetForQOS(NSQualityOfService qos) {
    static ZGDispatchContext *context[5] = {0};
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[0] = ZGDispatchContextCreate("com.lt.zgkit.user-interactive", count, qos);
            });
            return context[0];
        }
        case NSQualityOfServiceUserInitiated: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[1] = ZGDispatchContextCreate("com.lt.zgkit.user-initiated", count, qos);
            });
            return context[1];
        }
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[2] = ZGDispatchContextCreate("com.lt.zgkit.utility", count, qos);
            });
            return context[2];
        }
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[3] = ZGDispatchContextCreate("com.lt.zgkit.background", count, qos);
            });
            return context[3];
        }
            
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = ZGDispatchContextCreate("com.lt.zgkit.default", count, qos);
            });
            return context[4];
        }
    }
}

@implementation ZGDispatchQueuePool {
    ZGDispatchContext *_context;
}

- (void)dealloc {
    if (_context) {
        ZGDispatchContextRelease(_context);
        _context = NULL;
    }
}

- (instancetype)initWithContext:(ZGDispatchContext *)context {
    self = [super init];
    if (!context) {
        return nil;
    }
    self->_context = context;
    _name = context->name ? [NSString stringWithUTF8String:context->name] : nil;
    return self;
}

- (instancetype)initWithName:(NSString *)name
                  queueCount:(NSUInteger)queueCount
                         qos:(NSQualityOfService)qos {
    if (queueCount == 0 || queueCount > MAX_QUEUE_COUNT) return nil;
    self = [super init];
    _context = ZGDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
    if (!_context) return nil;
    _name = name;
    return self;
}

+ (instancetype)defaultPoolForQos:(NSQualityOfService)qos {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static ZGDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[ZGDispatchQueuePool alloc] initWithContext:ZGDispatchContextGetForQOS(qos)];
            });
            return pool;
        }
        case NSQualityOfServiceUserInitiated: {
            static ZGDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[ZGDispatchQueuePool alloc] initWithContext:ZGDispatchContextGetForQOS(qos)];
            });
            return pool;
        }
        case NSQualityOfServiceUtility: {
            static ZGDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[ZGDispatchQueuePool alloc] initWithContext:ZGDispatchContextGetForQOS(qos)];
            });
            return pool;
        }
        case NSQualityOfServiceBackground: {
            static ZGDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[ZGDispatchQueuePool alloc] initWithContext:ZGDispatchContextGetForQOS(qos)];
            });
            return pool;
        }
        default: {
            static ZGDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[ZGDispatchQueuePool alloc] initWithContext:ZGDispatchContextGetForQOS(qos)];
            });
            return pool;
        }
    }
}

- (dispatch_queue_t)queue {
    return ZGDispatchContextGetQueue(_context);
}

@end

dispatch_queue_t ZGDispatchQueueGetForQOS(NSQualityOfService qos) {
    return ZGDispatchContextGetQueue(ZGDispatchContextGetForQOS(qos));
}
