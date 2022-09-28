//
//  LTThreadSafeDictionary.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/28.
//

#import "LTThreadSafeDictionary.h"
#import "LTThreadSafeProxy.h"

@implementation LTThreadSafeDictionary

+ (instancetype)alloc {
    return [self mutableDictionaryProxy];
}

+ (instancetype)dictionary {
    return [self mutableDictionaryProxy];
}

+ (instancetype)mutableDictionaryProxy {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    LTThreadSafeProxy *proxy = [[LTThreadSafeProxy alloc] initWithTarget:dic];
    
    return proxy;
}

@end
