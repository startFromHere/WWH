//
//  ZGDispatchQueuePool.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/27.
//

#import <Foundation/Foundation.h>

#ifndef ZGDispatchQueuePool_h
#define ZGDispatchQueuePool_h

NS_ASSUME_NONNULL_BEGIN

@interface ZGDispatchQueuePool : NSObject

@property (nullable, nonatomic, readonly) NSString *name;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithName:(nullable NSString *)name
                  queueCount:(NSUInteger)queueCount
                         qos:(NSQualityOfService)qos;

- (dispatch_queue_t)queue;

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos;

@end

extern dispatch_queue_t ZGDispatchQueueGetForQOS(NSQualityOfService qos);

NS_ASSUME_NONNULL_END

#endif
