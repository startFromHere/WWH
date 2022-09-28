//
//  LTThreadSafeArray.m
//  LTOCTest
//
//  Created by 刘涛 on 2022/9/27.
//

#import "LTThreadSafeArray.h"
#import "LTThreadSafeProxy.h"

@implementation LTThreadSafeArray

+ (instancetype)alloc {
    return [self mutableArrayProxy];
}

+ (instancetype)array {
    return [self mutableArrayProxy];
}

+ (instancetype)mutableArrayProxy {
    NSMutableArray *arr = [NSMutableArray array];
    LTThreadSafeProxy *proxy = [[LTThreadSafeProxy alloc] initWithTarget:arr];
    
    return proxy;
}

@end
