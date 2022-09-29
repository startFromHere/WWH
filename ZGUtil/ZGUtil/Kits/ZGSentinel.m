//
//  ZGSentinel.m
//  LTDemo
//
//  Created by 刘涛 on 2022/9/29.
//

#import "ZGSentinel.h"
#import <libkern/OSAtomic.h>>

@implementation ZGSentinel {
    int32_t _value;
}

- (int32_t)value {
    return _value;
}

- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}

@end
