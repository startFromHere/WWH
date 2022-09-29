//
//  LTThreadSafeProxy.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/28.
//

#import "LTThreadSafeProxy.h"

@implementation LTThreadSafeProxy {
    dispatch_semaphore_t _semaphore;
    id _target;
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    _semaphore = dispatch_semaphore_create(1);
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [anInvocation invokeWithTarget:_target];
    dispatch_semaphore_signal(_semaphore);
}

+ (NSMutableArray *)threadSafeMutableArray {
    return [self _threadSafeObjectOfClass:[NSMutableArray class]];
}

+ (NSMutableDictionary *)threadSafeMutableDictionary {
    return [self _threadSafeObjectOfClass:[NSMutableDictionary class]];
}

+ (id)_threadSafeObjectOfClass:(Class)cls {
    NSMutableArray *innerObj = [[cls alloc] init];
    LTThreadSafeProxy *proxy = [[LTThreadSafeProxy alloc] initWithTarget:innerObj];
    
    return proxy;
}

@end
