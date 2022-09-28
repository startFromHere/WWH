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

@end
