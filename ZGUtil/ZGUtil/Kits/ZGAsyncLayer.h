//
//  ZGAsyncLayer.h
//  LTDemo
//
//  Created by 刘涛 on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ZGAsyncLayerDisplayTask;
NS_ASSUME_NONNULL_BEGIN

@interface ZGAsyncLayer : CALayer

@property (nonatomic, assign) BOOL displayAsynchronously;

@end

@protocol ZGAsyncLayerDelegate <NSObject>
@required
- (ZGAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end

@interface ZGAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void(^willDisplay)(CALayer *layer);
@property (nullable, nonatomic, copy) void(^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));
@property (nullable, nonatomic, copy) void(^didDisplay)(CALayer *layer, BOOL finished);

@end

NS_ASSUME_NONNULL_END
