//
//  ViewController.m
//  ZGUtil
//
//  Created by 刘涛 on 2022/9/27.
//

#import "ViewController.h"
#import "LTThreadSafeProxy.h"

@interface ViewController ()

@property (nonnull, strong) dispatch_queue_t queue;

@end


#define fuc() {   \
int a = 0;  \
int b = 1;  \
a = a + b;  \
}
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _queue = dispatch_queue_create("com.lt.queue", DISPATCH_QUEUE_CONCURRENT);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self threadSafeArrayTest];
    if (1 == 0){}
//        fuc()
    else {
        NSLog(@"aha");
    }

}

- (void)threadSafeArrayTest {
    NSMutableArray *mArray = [LTThreadSafeProxy threadSafeMutableArray];
    
//    dispatch_queue_attr_t queueAtt = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_DEFAULT, 0);
//    dispatch_queue_t queue = dispatch_queue_create("com.lt.queue", queueAtt);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(_queue, ^{
        for (int i = 0; i < 50; i++) {
            [mArray addObject:@(i)];
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(_queue, ^{
        for (int i = 0; i < 50; i++) {
            [mArray addObject:@(i+50)];
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"arr:%@", mArray);
    });
    
    NSLog(@"aha");
}

- (void)threadSafeDictionaryTest {
    NSMutableDictionary *mDic = [LTThreadSafeProxy threadSafeMutableDictionary];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(_queue, ^{
        for (int i = 0; i < 50; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", i];
            mDic[key] = @(i);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(_queue, ^{
        for (int i = 0; i < 50; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", i];
            mDic[key] = @(i);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"dic:%@", mDic);
    });
    
    NSLog(@"aha");
}


@end
