//
//  ZGTextArchiver.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGTextArchiver : NSKeyedArchiver <NSKeyedArchiverDelegate>
@end

@interface ZGTextUnarchiver : NSKeyedUnarchiver <NSKeyedUnarchiverDelegate>
@end

NS_ASSUME_NONNULL_END
