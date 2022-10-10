//
//  NSObject+ZGAdd.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZGAdd)

- (nullable id)performSelectorWithArgs:(SEL)sel, ...;
- (void)performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;
- (nullable id)performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDonw:(BOOL)wait;
- (nullable id)performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDonw:(BOOL)wait, ...;
- (void)performSelectorWithArgsInBackground:(SEL)sel, ...;
- (void)performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssiciateWeakValue:(nullable id)value withKey:(void *)key;
- (nullable id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;
+ (NSString *)className;
- (NSString *)className;
- (nullable id)deepCopy;
- (nullable id)deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

@end

NS_ASSUME_NONNULL_END
