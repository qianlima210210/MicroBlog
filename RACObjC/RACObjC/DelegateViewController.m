//
//  DelegateViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/18.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "DelegateViewController.h"
#import "ContentView.h"


@interface DelegateViewController ()
@property (nonatomic, assign) int time;
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation DelegateViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ContentView *contentView = [[ContentView alloc]initWithFrame:CGRectMake(0, 88, 300, 300)];
    [self.view addSubview:contentView];
    
    [contentView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [[contentView rac_signalForSelector:@selector(sendValue:dic:)]subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@, %@", x[0], x[1]);
    }];
    
    // 监听通知
    // __weak typeof(self) weakSelf = self ;
   
    @weakify(self);
     [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NotificationName" object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);//变量作用域结束之前，对 weak_self 有一个强引用，防止对象(self)提前被释放
        [self receivedData:x];
    }];
    
    //[self demo7];
}

-(void)receivedData:(NSNotification*)x{
    NSLog(@"%@", x);
}

-(void)demo7{
    self.time = 3;
        
    //这个就是RAC中的GCD
    @weakify(self)
    self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
        @strongify(self)
        
        self.time --;
        NSString * title = self.time > 0 ? [NSString stringWithFormat:@"请等待 %d 秒后重试", self.time] : @"发送验证码";
        NSLog(@"%@",title);
        
        if (self.time == 0) {
            [self.disposable dispose];//结束计时器
        }
    }];
    
     NSLog(@"%@",@"请等待 10 秒后重试");
}

@end
