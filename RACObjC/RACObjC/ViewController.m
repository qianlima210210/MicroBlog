//
//  ViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/15.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RGBViewController.h"
#import "RequestViewController.h"
#import "DelegateViewController.h"
#import "MainClassViewController.h"
#import "SeasonViewController.h"

@import ReactiveObjC;

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)test:(id)sender {
    SeasonViewController *vc = [[SeasonViewController alloc]initWithNibName:@"SeasonViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    /*
    RACSignal *signal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext = %@", x);
    }];
    
    [signal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"subscribeError = %@", error);
    }];
    
    [signal subscribeCompleted:^{
        NSLog(@"subscribeCompleted");
    }];
    
    RACCommand *command = [[RACCommand alloc]initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"=====");
            //订购者先消费信号，消费完后再next or complete or error
            [subscriber sendNext:[NSDate date].description];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    [btn setRac_command:command];
    [[btn rac_command].executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"----");
        }];
    }];
    */
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@", x);
        //改变btn的Frame
        x.frame = CGRectMake(100,100,200, 200);
        
    }];
    
//    [[btn rac_valuesForKeyPath:@"frame" observer:self]subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    [[btn rac_valuesAndChangesForKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        //RACTwoTuple是一个集合类型，可以用数组的方式获取到里面的内容。
        NSLog(@"frame改变了%@",x.second);
    }];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


@end
