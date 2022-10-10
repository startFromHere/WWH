//
//  UIFont+YYAdd.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/30.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZGAdd) <NSCoding>

@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0);

- (nullable UIFont *)fontWithBold NS_AVAILABLE_IOS(7_0);

- (nullable UIFont *)fontWithItalic NS_AVAILABLE_IOS(7_0);

- (nullable UIFont *)fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

- (nullable UIFont *)fontWithNormal NS_AVAILABLE_IOS(7_0);

+ (nullable UIFont *)fontWithCTFont:(CTFontRef)CTFont;

+ (nullable UIFont *)fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

- (nullable CTFontRef)CTFontRef CF_RETURNS_RETAINED;

- (nullable CGFontRef)CGFontRef CF_RETURNS_RETAINED;

+ (BOOL)loadFontFromPath:(NSString *)path;

+ (void)unloadFontFromPath:(NSString *)path;

+ (nullable UIFont *)loadFontFromData:(NSData *)data;

+ (BOOL)unloadFontFromData:(UIFont *)font;

+ (nullable NSData *)dataFromCGFont:(CGFontRef)cgFont;

@end

NS_ASSUME_NONNULL_END
