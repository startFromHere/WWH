//
//  ZGSentinel.h
//  LTDemo
//
//  Created by 刘涛 on 2022/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGSentinel : NSObject

@property (readonly) int32_t value;

- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END
