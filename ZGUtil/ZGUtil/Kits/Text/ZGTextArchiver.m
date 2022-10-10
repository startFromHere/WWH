//
//  ZGTextArchiver.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import "ZGTextArchiver.h"
#import "ZGTextRunDelegate.h"
#import "ZGTextRubyAnnotation.h"
#import "UIDevice+ZGAdd.h"

static CFTypeID CTRunDelegateTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ZGTextRunDelegate *delegate = [ZGTextRunDelegate new];
        CTRunDelegateRef ref = delegate.CTRunDelegate;
        typeID = CFGetTypeID(ref);
        CFRelease(ref);
    });
    return typeID;
}

static CFTypeID CTRubyAnnotationTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((long)CTRubyAnnotationTypeID + 1 > 1) {
            typeID = CTRunDelegateGetTypeID();
        } else {
            typeID = kCFNotFound;
        }
    });
    return typeID;
}

@interface _ZGCGColor : NSObject <NSCopying, NSCoding>
@property (nonatomic, assign) CGColorRef CGColor;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;
@end

@implementation _ZGCGColor

+ (instancetype)colorWithCGColor:(CGColorRef)CGColor {
    _ZGCGColor *color = [self new];
    color.CGColor = CGColor;
    return color;
}

- (void)setCGColor:(CGColorRef)CGColor {
    if (_CGColor != CGColor) {
        if (CGColor) {
            CGColor = (CGColorRef)CFRetain(CGColor);
        }
        if (_CGColor) {
            CFRelease(_CGColor);
        }
        _CGColor = CGColor;
    }
}

- (void)dealloc {
    if (_CGColor) {
        CFRelease(_CGColor);
    }
    _CGColor = NULL;
}

- (id)copyWithZone:(NSZone *)zone {
    _ZGCGColor *color = [self.class new];
    color.CGColor = self.CGColor;
    return color;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    UIColor *color = [UIColor colorWithCGColor:_CGColor];
    [coder encodeObject:color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    UIColor *color = [coder decodeObjectForKey:@"color"];
    self.CGColor = color.CGColor;
    return self;
}

@end

@interface _ZGCGImage : NSObject <NSCoding, NSCopying>
@property (nonatomic, assign) CGImageRef CGImage;
+ (instancetype)imageWithCGImage:(CGImageRef)CGImage;
@end

@implementation _ZGCGImage

+ (instancetype)imageWithCGImage:(CGImageRef)CGImage {
    _ZGCGImage *image = [self new];
    image.CGImage = CGImage;
    return image;
}

- (void)setCGImage:(CGImageRef)CGImage {
    if (_CGImage != CGImage) {
        if (CGImage) {
            CGImage = (CGImageRef)CFRetain(CGImage);
        }
        if (_CGImage) {
            CFRelease(_CGImage);
        }
        _CGImage = CGImage;
    }
}

- (void)dealloc {
    if (_CGImage) {
        CFRelease(_CGImage);
    }
}

- (id)copyWithZone:(NSZone *)zone {
    _ZGCGImage *image = [self.class new];
    image.CGImage= self.CGImage;
    return image;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    UIImage *image = [UIImage imageWithCGImage:_CGImage];
    [coder encodeObject:image forKey:@"image"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    UIImage *image = [coder decodeObjectForKey:@"image"];
    self.CGImage = image.CGImage;
    return self;
}

@end

@implementation ZGTextArchiver

+ (NSData *)archivedDataWithRootObject:(id)rootObject {
    if (!rootObject) {
        return nil;
    }
    NSMutableData *data = [NSMutableData data];
    ZGTextArchiver *archiver = [[[self class] alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:rootObject];
    [archiver finishEncoding];
    return data;
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path {
    NSData *data = [self archivedDataWithRootObject:rootObject];
    if (!data) {
        return NO;
    }
    return [data writeToFile:path atomically:YES];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForWritingWithMutableData:(NSMutableData *)data {
    self = [super initForWritingWithMutableData:data];
    self.delegate = self;
    return self;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    CFTypeID typeID = CFGetTypeID((CFTypeRef)object);
    if (typeID == CTRunDelegateTypeID()) {
        CTRunDelegateRef runDelegate = (__bridge  CFTypeRef)(object);
        id ref = CTRunDelegateGetRefCon(runDelegate);
        if (ref) return ref;
    } else if (typeID == CTRubyAnnotationTypeID()) {
        CTRubyAnnotationRef ctRuby = (__bridge  CFTypeRef)(object);
        ZGTextRubyAnnotation *ruby = [ZGTextRubyAnnotation rubyWithCTRubyRef:ctRuby];
        if (ruby) {
            return ruby;
        }
    } else if (typeID == CGColorGetTypeID()) {
        return [_ZGCGColor colorWithCGColor:(CGColorRef)object];
    } else if (typeID == CGImageGetTypeID()) {
        return [_ZGCGImage imageWithCGImage:(CGImageRef)object];
    }
    return object;
}

@end

@implementation ZGTextUnarchiver

+ (id)unarchiveObjectWithData:(NSData *)data {
    if (data.length == 0) {
        return nil;
    }
    ZGTextArchiver *unarchiver = [[self alloc] initForReadingWithData:data];
    return [unarchiver decodeObject];
}

+ (id)unarchiveObjectWithFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self unarchiveObjectWithData:data];
}

- (instancetype)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super initForReadingWithData:data];
    self.delegate = self;
    return self;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    if ([object class] == [ZGTextRunDelegate class]) {
        ZGTextRunDelegate *runDelegate = object;
        CTRunDelegateRef ct = runDelegate.CTRunDelegate;
        id ctObj = (__bridge id)ct;
        if (ct) {
            CFRelease(ct);
        }
        return ctObj;
    } else if ([object class] == [ZGTextRubyAnnotation class]) {
        ZGTextRubyAnnotation *ruby = object;
        if (kiOS8Later) {
            CTRubyAnnotationRef ct = ruby.CTRubyAnnotation;
            id ctObj = (__bridge  id)(ct);
            if (ct) CFRelease(ct);
            return ctObj;
        } else {
            return object;
        }
    } else if ([object class] == [_ZGCGColor class]) {
        _ZGCGColor *color = object;
        return (id)color.CGColor;
    } else if ([object class] == [_ZGCGImage class]) {
        _ZGCGImage *image = object;
        return (id)image.CGImage;
    }
    return object;
 }

@end
