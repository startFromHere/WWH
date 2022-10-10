//
//  ZGTextRubyAnnotation.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import "ZGTextRubyAnnotation.h"

@implementation ZGTextRubyAnnotation

- (instancetype)init {
    self = super.init;
    self.alignment = kCTRubyAlignmentAuto;
    self.overhang = kCTRubyOverhangAuto;
    self.sizeFactor = 0.5;
    return self;
}

+ (instancetype)rubyWithCTRubyRef:(CTRubyAnnotationRef)ctRuby {
    if (!ctRuby) {
        return nil;
    }
    
    ZGTextRubyAnnotation *one = [self new];
    one.alignment = CTRubyAnnotationGetAlignment(ctRuby);
    one.overhang = CTRubyAnnotationGetOverhang(ctRuby);
    one.sizeFactor = CTRubyAnnotationGetSizeFactor(ctRuby);
    one.textBefore = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionBefore));
    one.textAfter = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionAfter));
    one.textInterCharacter = (__bridge  NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInterCharacter));
    one.textInline = (__bridge  NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInline));
    return one;
}

- (CTRubyAnnotationRef)CTRubyAnnotation CF_RETURNS_RETAINED {
    if (((long)CTRubyAnnotationCreate + 1) == 1) {
        return NULL;
    }
    
    CFStringRef text[kCTRubyPositionCount];
    text[kCTRubyPositionBefore] = (__bridge  CFStringRef)(_textBefore);
    text[kCTRubyPositionAfter] = (__bridge  CFStringRef)(_textAfter);
    text[kCTRubyPositionInterCharacter] = (__bridge  CFStringRef)(_textInterCharacter);
    text[kCTRubyPositionInline] = (__bridge  CFStringRef)(_textInline);
    CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(_alignment, _overhang, _sizeFactor, text);
    return ruby;
}

- (id)copyWithZone:(NSZone *)zone {
    ZGTextRubyAnnotation *one = [self.class new];
    one.alignment = _alignment;
    one.overhang = _overhang;
    one.sizeFactor = _sizeFactor;
    one.textBefore = _textBefore;
    one.textAfter = _textAfter;
    one.textInterCharacter = _textInterCharacter;
    one.textInline = _textInline;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_alignment forKey:@"aligment"];
    [coder encodeInteger:_overhang forKey:@"overhang"];
    [coder encodeInteger:_sizeFactor forKey:@"sizeFactor"];
    [coder encodeObject:_textBefore forKey:@"textBefore"];
    [coder encodeObject:_textAfter forKey:@"textAfter"];
    [coder encodeObject:_textInterCharacter forKey:@"textInterChatacter"];
    [coder encodeObject:_textInline forKey:@"textInline"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    _alignment = [coder decodeIntegerForKey:@"alignment"];
    _overhang = [coder decodeIntegerForKey:@"overhang"];
    _sizeFactor = [coder decodeIntegerForKey:@"sizeFactor"];
    _textBefore = [coder decodeObjectForKey:@"textBefore"];
    _textAfter = [coder decodeObjectForKey:@"textAfter"];
    _textInterCharacter = [coder decodeObjectForKey:@"textInterCharacter"];
    _textInline = [coder decodeObjectForKey:@"textInline"];
    return self;
}

@end
