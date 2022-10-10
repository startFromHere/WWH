//
//  NSParagraphStyle+ZGAdd.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSParagraphStyle (ZGAdd)

+ (nullable NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;
- (nullable CTParagraphStyleRef)CTStyle CF_RETURNS_RETAINED;

@end

NS_ASSUME_NONNULL_END
