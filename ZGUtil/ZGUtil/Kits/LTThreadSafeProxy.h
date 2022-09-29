//
//  LTThreadSafeProxy.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTThreadSafeProxy : NSProxy

- (instancetype)initWithTarget:(id)target;

+ (NSMutableArray *)threadSafeMutableArray;

+ (NSMutableDictionary *)threadSafeMutableDictionary;

@end

NS_ASSUME_NONNULL_END
