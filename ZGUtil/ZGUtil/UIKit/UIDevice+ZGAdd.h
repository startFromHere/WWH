//
//  UIDevice+ZGAdd.h
//  ZGUtil
//
//  Created by 刘涛 on 2022/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZGAdd)

+ (double)systemVersion;

@property (nonatomic, readonly) BOOL isPad;
@property (nonatomic, readonly) BOOL isSimulator;
@property (nonatomic, readonly) BOOL isJailbroken;
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
@property (nullable, nonatomic, readonly) NSString *machineModel;
@property (nullable, nonatomic, readonly) NSString *machineModelName;
@property (nonatomic, readonly) NSDate *systemUptime;
@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;
@property (nullable, nonatomic, readonly) NSString *idAddressCell;

typedef NS_OPTIONS(NSUInteger, ZGNetworkTrafficType) {
    ZGNetworkTrafficTypeWWANSent        = 1 << 0,
    ZGNetworkTrafficTypeWWANReceived    = 1 << 1,
    ZGNetworkTrafficTypeWIFISent        = 1 << 2,
    ZGNetworkTrafficTypeWIFIReceived    = 1 << 3,
    ZGNetworkTrafficTypeAWDLSent        = 1 << 4,
    ZGNetworkTrafficTypeAWDLReceived    = 1 << 5,
    
    ZGNetworkTrafficTypeWWAN = ZGNetworkTrafficTypeWWANSent | ZGNetworkTrafficTypeWWANReceived,
    ZGNetworkTrafficTypeWIFI = ZGNetworkTrafficTypeWIFISent | ZGNetworkTrafficTypeWIFIReceived,
    ZGNetworkTrafficTypeAWDL = ZGNetworkTrafficTypeAWDLSent | ZGNetworkTrafficTypeAWDLReceived,
    
    ZGNetworkTrafficTypeALL = ZGNetworkTrafficTypeWWAN |
                              ZGNetworkTrafficTypeWIFI |
                              ZGNetworkTrafficTypeAWDL,
};


@end

NS_ASSUME_NONNULL_END

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

