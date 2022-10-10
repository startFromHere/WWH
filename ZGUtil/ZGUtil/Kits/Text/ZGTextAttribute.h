//
//  ZGTextAttribute.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ZGTextAttributeType) {
    ZGTextAttributeTypeNone     = 0,
    ZGTextAttributeTypeUIKit    = 1 << 0,
    ZGTextAttributeTypeCoreText = 1 << 1,
    ZGTextAttributeTypeZGText   = 1 << 2,
};

extern ZGTextAttributeType ZGTextAttributeGetType(NSString *attributeName);

typedef NS_OPTIONS(NSInteger, ZGTextLineStyle) {
    ZGTextLineStyleNone     = 0x00,
    ZGTextLineStyleSingle   = 0x01,
    ZGTextLineStyleThick    = 0x02,
    ZGTextLineStyleDouble   = 0x09,
    
    ZGTextLineStylePatternSolid      = 0x000,
    ZGTextLineStylePatternDot        = 0x100,
    ZGTextLineStylePatternDash       = 0x200,
    ZGTextLineStylePatternDashDot    = 0x300,
    ZGTextLineStylePatternDashDotDot = 0x400,
    ZGTextLineStylePatternCircleDot  = 0x900,
};

typedef NS_ENUM(NSUInteger, ZGTextVerticalAlignment) {
    ZGTextVerticalAlignmentTop    = 0,
    ZGTextVerticalAlignmentCenter = 1,
    ZGTextVerticalAlignmentBottom = 2,
};

typedef NS_OPTIONS(NSUInteger, ZGTextDirection) {
    ZGTextDirectionNone     = 0,
    ZGTextDirectionTop      = 1 << 0,
    ZGTextDirectionRight    = 1 << 1,
    ZGTextDirectionBottom   = 1 << 2,
    ZGTextDirectionLeft     = 1 << 3,
};

typedef NS_ENUM(NSUInteger, ZGTextTruncationType) {
    ZGTextTruncationTypeNone    = 0,
    ZGTextTruncationTypeStart   = 1,
    ZGTextTruncationTypeEnd     = 2,
    ZGTextTruncationTypeMiddle  = 3
};

UIKIT_EXTERN NSString *const ZGTextBackedStringAttributeName;
UIKIT_EXTERN NSString *const ZGTextBindingAttributeName;
UIKIT_EXTERN NSString *const ZGTextShadowAttributeName;
UIKIT_EXTERN NSString *const ZGTextInnerShadowAttributeName;
UIKIT_EXTERN NSString *const ZGTextUnderlineAttributeName;
UIKIT_EXTERN NSString *const ZGTextStrikethroughAttributeName;
UIKIT_EXTERN NSString *const ZGTextBorderAttributeName;
UIKIT_EXTERN NSString *const ZGTextBackgroundBorderAttributeName;
UIKIT_EXTERN NSString *const ZGTextBlockBorderAttributeName;
UIKIT_EXTERN NSString *const ZGTextAttachmentAttributeName;
UIKIT_EXTERN NSString *const ZGTextHighlightAttributeName;
UIKIT_EXTERN NSString *const ZGTextGlyphTransformAttributeName;

UIKIT_EXTERN NSString *const ZGTextAttachmentToken;
UIKIT_EXTERN NSString *const ZGTextTruncationToken;

typedef void(^ZGTextAction)(UIView *containerView, NSAttributedString *text, NSRange *range, CGRect rect);

@interface ZGTextBackedString: NSObject <NSCoding, NSCopying>
+ (instancetype)stringWithString:(nullable NSString *)string;
@property (nullable, nonatomic, copy) NSString *string;
@end

@interface ZGTextBinding : NSObject <NSCoding, NSCopying>
+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm;
@property (nonatomic) BOOL deleteConfirm;
@end

@interface ZGTextShadow : NSObject <NSCoding, NSCopying>
+ (instancetype)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
@property (nullable, nonatomic, strong) UIColor *color;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGBlendMode blendMode;
@property (nullable, nonatomic, strong) ZGTextShadow *subShadow;

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow;
- (NSShadow *)nsShadow;
@end

@interface ZGTextDecoration : NSObject <NSCoding, NSCopying>
+ (instancetype)decorationWithStyle:(ZGTextLineStyle)style;
+ (instancetype)decorationWithStyle:(ZGTextLineStyle)style width:(nullable NSNumber *)width color:(nullable UIColor *)color;
@property (nonatomic) ZGTextLineStyle style;
@property (nullable, nonatomic, strong) NSNumber *width;
@property (nullable, nonatomic, strong) UIColor *color;
@property (nullable, nonatomic, strong) ZGTextShadow *shadow;
@end

@interface ZGTextBorder : NSObject <NSCoding, NSCopying>
+ (instancetype)borderWithLineStyle:(ZGTextLineStyle)lineStyle lineWidth:(CGFloat)width stroleColor:(nullable UIColor *)color;
+ (instancetype)borderWithFillColor:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic) ZGTextLineStyle lineStyle;
@property (nonatomic) CGFloat strokeWidth;
@property (nullable, nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) CGLineJoin lineJoin;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) CGFloat cornerRadius;
@property (nullable, nonatomic, strong) ZGTextShadow *shadow;
@property (nullable, nonatomic, strong) UIColor *fillColor;
@end

@interface ZGTextAttachment : NSObject<NSCoding, NSCopying>
+ (instancetype)attachmentWithContent:(nullable id)content;
@property (nullable, nonatomic, strong) id content;
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic) UIEdgeInsets contentInsets;
@property (nullable, nonatomic, strong) NSDictionary *userInfo;
@end

@interface ZGTextHighlight : NSObject <NSCoding, NSCopying>
@property (nullable, nonatomic, copy) NSDictionary<NSString *, id> *attributes;
+ (instancetype)highlightWithAttributes:(nullable NSDictionary<NSString *, id>*)attributes;
+ (instancetype)highlightWithBackgroundColor:(nullable UIColor *)color;
- (void)setFont:(nullable UIFont *)font;
- (void)setColor:(nullable UIColor *)color;
- (void)setStrokeWidth:(nullable NSNumber *)width;
- (void)setStrokeColor:(nullable UIColor *)color;
- (void)setShadow:(nullable ZGTextShadow *)shadow;
- (void)setInnerShadow:(nullable ZGTextShadow *)shadow;
- (void)setUnderline:(nullable ZGTextDecoration *)underline;
- (void)setStrikethrough:(nullable ZGTextDecoration *)strikethrough;
- (void)setBackgroundBorder:(nullable ZGTextBorder *)border;
- (void)setBorder:(nullable ZGTextBorder *)border;
- (void)setAttachment:(nullable ZGTextAttachment *)attachment;
@property (nullable, nonatomic, copy) NSDictionary *userInfo;
@property (nullable, nonatomic, copy) ZGTextAction tapAction;
@property (nullable, nonatomic, copy) ZGTextAction longPressAction;
@end

NS_ASSUME_NONNULL_END
