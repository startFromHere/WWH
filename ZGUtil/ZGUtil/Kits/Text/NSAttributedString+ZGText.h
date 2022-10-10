//
//  NSAttributedString+ZGText.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#if __has_include(<ZGKit/ZGKit.h>)
#import <ZGKit/ZGTextAttribute.h>
#import <ZGKit/ZGTextRubyAnnotation.h>
#else
#import "ZGTextAttribute.h"
#import "ZGTextRubyAnnotation.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZGText)

- (nullable NSData *)archiveToData;
+ (nullable instancetype)unarchiveFromData:(NSData *)data;
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, id> *attributes;
- (nullable NSDictionary<NSString *, id> *)attributesAtIndex:(NSUInteger)index;
- (nullable id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIFont *font;
- (nullable UIFont *)fontAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *kern;
- (nullable NSNumber *)kernAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *color;
- (nullable UIColor *)colorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) UIColor *backgroundColor;
- (nullable UIColor *)backgroundColorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *strokeWidth;
- (nullable NSNumber *)strokeWidthAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSNumber *strokeColor;
- (nullable NSNumber *)strokeColorAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readonly) NSShadow *shadow;
- (nullable NSShadow *)shadowAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSUnderlineStyle strikethroughStyle;
- (NSUnderlineStyle)strikethroughStyleAtIndex:(NSUInteger)index;
@property (nullable, nonatomic, strong, readwrite) UIColor *strikethroughColor;
- (void)setStrikethroughColor:(nullable UIColor *)strikethroughColor range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readwrite) NSUnderlineStyle underlineStyle;
- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) UIColor *underlineColor;
- (void)setUnderlineColor:(nullable UIColor *)underlineColor range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSNumber *ligature;
- (void)setLigature:(nullable NSNumber *)ligature range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSString *textEffect;
- (void)setTextEffect:(nullable NSString *)textEffect range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *obliqueness;
- (void)setObliqueness:(nullable NSNumber *)obliqueness range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *expansion;
- (void)setExpansion:(nullable NSNumber *)expansion range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSNumber *baselineOffset;
- (void)setBaselineOffset:(nullable NSNumber *)baselineOffset range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readwrite) BOOL verticalGlyphForm;
- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSString *language;
- (void)setLanguage:(nullable NSString *)language range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) NSArray<NSNumber *> *writingDirection;
- (void)setWritingDirection:(nullable NSArray<NSNumber *> *)writingDirection range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) NSParagraphStyle *paragraphStyle;
- (void)setParagraphStyle:(nullable NSParagraphStyle *)paragraphStyle range:(NSRange)range;
@property (nonatomic, readwrite) NSTextAlignment alignment;
- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range;
@property (nonatomic, readwrite) NSLineBreakMode lineBreakMode;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat lineSpacing;
- (void)setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat paragraphSpacing;
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat paragraphSpacingBefore;
- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat firstLineHeadIndent;
- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat headIndent;
- (void)setHeadIndent:(CGFloat)headIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat tailIndent;
- (void)setTailIndent:(CGFloat)tailIndent range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat minimumLineHeight;
- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat maximumLineHeight;
- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat lineHeightMultiple;
- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;
@property (nonatomic, readwrite) NSWritingDirection baseWritingDirection;
- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;
@property (nonatomic, readwrite) float hyphenationFactor;
- (void)setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;
@property (nonatomic, readwrite) CGFloat defaultTabInterval;
- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, copy, readwrite) NSArray<NSTextTab *> *tabStops;
- (void)setTabStops:(nullable NSArray<NSTextTab *> *)tabStops range:(NSRange)range NS_AVAILABLE_IOS(7_0);
@property (nullable, nonatomic, strong, readwrite) ZGTextShadow *textShadow;
- (void)setTextShadow:(nullable ZGTextShadow *)textShadow range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) ZGTextShadow *textInnerShadow;
- (void)setTextInnerShadow:(nullable ZGTextShadow *)textInnerShadow range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) ZGTextDecoration *textUnderline;
- (void)setTextUnderline:(nullable ZGTextDecoration *)textUnderline range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) ZGTextDecoration *textStrikethrough;
- (void)setTextStrikethrough:(nullable ZGTextDecoration *)textStrikethrough range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) ZGTextBorder *textBorder;
- (void)setTextBorder:(nullable ZGTextBorder *)textBorder range:(NSRange)range;
@property (nullable, nonatomic, strong, readwrite) ZGTextBorder *textBackgroundBorder;
- (void)setTextBackgroundBorder:(nullable ZGTextBorder *)textBackgroundBorder range:(NSRange)range;
@property (nonatomic, readwrite) CGAffineTransform textGlyphTransform;
- (void)setTextGlyphTransform:(CGAffineTransform)textGlyphTransform range:(NSRange)range;

- (void)setSuperscript:(nullable NSNumber *)superscript range:(NSRange)range;
- (void)setGlyphInfo:(nullable CTGlyphInfoRef)glyphInfo range:(NSRange)range;
- (void)setCharacterShape:(nullable NSNumber *)characterShape range:(NSRange)range;
- (void)setRunDelegate:(nullable CTRunDelegateRef)runDelegate range:(NSRange)range;
- (void)setBaselineClass:(nullable CFStringRef)baselineClass range:(NSRange)range;
- (void)setBaselineInfo:(nullable CFDictionaryRef)baselineInfo range:(NSRange)range;
- (void)setBaselineReferenceInfo:(nullable CFDictionaryRef)referenceInfo range:(NSRange)range;
- (void)setRubyAnnotation:(nullable CTRubyAnnotationRef)ruby range:(NSRange)range NS_AVAILABLE_IOS(8_0);
- (void)setAttachment:(nullable NSTextAttachment *)attachment range:(NSRange)range NS_AVAILABLE_IOS(7_0);
- (void)setLink:(nullable id)link range:(NSRange)range NS_AVAILABLE_IOS(7_0);
- (void)setTextBackedString:(nullable ZGTextBackedString *)textBackedString range:(NSRange)range;
- (void)setTextBinding:(nullable ZGTextBinding *)textBinding range:(NSRange)range;
- (void)setTextAttachment:(nullable ZGTextAttachment *)textAttachment range:(NSRange)range;
- (void)setTextHighlight:(nullable ZGTextHighlight *)textHighlight range:(NSRange)range;
- (void)setTextBlockBorder:(nullable ZGTextBorder *)textBlockBorder range:(NSRange)range;
- (void)setTextRubyAnnotation:(nullable ZGTextRubyAnnotation *)ruby range:(NSRange)range NS_AVAILABLE_IOS(8_0);

- (void)setTextHighlightRange:(NSRange)range
                        color:(nullable UIColor *)color
              backgroundColor:(nullable UIColor *)backgroundColor
                     userInfo:(nullable NSDictionary *)userInfo
                    tapAction:(nullable ZGTextAction)tapAction
              longPressAction:(nullable ZGTextAction)longPressAction;

- (void)setTextHighlightRange:(NSRange)range
                        color:(nullable UIColor *)color
              backgroundColor:(nullable UIColor *)backgroundColor
                    tapAction:(nullable ZGTextAction)tapAction;

- (void)insertString:(NSString *)string atIndex:(NSUInteger)location;

- (void)appendString:(NSString *)string;

- (void)setClearColorToJoinedEmoji;

- (void)removeDiscontinuousAttributesInRange:(NSRange)range;

+ (NSArray<NSString *> *)allDiscontinuousAttributeKeys;

@end

NS_ASSUME_NONNULL_END
