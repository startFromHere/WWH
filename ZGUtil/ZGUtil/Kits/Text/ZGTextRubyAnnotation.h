//
//  ZGTextRubyAnnotation.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGTextRubyAnnotation : NSObject <NSCopying, NSCoding>

@property (nonatomic) CTRubyAlignment alignment;
@property (nonatomic) CTRubyOverhang overhang;
@property (nonatomic) CGFloat sizeFactor;
@property (nullable, nonatomic, copy) NSString *textBefore;
@property (nullable, nonatomic, copy) NSString *textAfter;
@property (nullable, nonatomic, copy) NSString *textInterCharacter;
@property (nullable, nonatomic, copy) NSString *textInline;

+ (instancetype)rubyWithCTRubyRef:(CTRubyAnnotationRef)ctRuby NS_AVAILABLE_IOS(8_0);
- (nullable CTRubyAnnotationRef)CTRubyAnnotation CF_RETURNS_RETAINED NS_AVAILABLE_IOS(8_0);


@end

NS_ASSUME_NONNULL_END
