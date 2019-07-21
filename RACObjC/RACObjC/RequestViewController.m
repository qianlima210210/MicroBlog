//
//  RequestViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/17.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "RequestViewController.h"
#import <ReactiveObjC.h>

@interface RequestViewController ()

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    RACSignal* signal = [self signalForRequest];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"--2--");
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"complete");
    }];
}

- (RACSignal*)signalForRequest{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"--1--");//subscribeNext、error、complete均会触发该block的执行。
        
        NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:c];
        
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:data];
                [subscriber sendCompleted];
                
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposableWithBlock");
        }];
    }];
    
    
    return signal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self sequenceMethod];
}

- (void)executeOneTime{
    __block int temp = 10;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        temp += 10;
        [subscriber sendNext:[NSNumber numberWithInt:temp]];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }]replayLast];//replayLast保证只执行一次，并记录结果
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %d", [x intValue]);
    }];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %d", [x intValue]);
    }];
}

- (void)sequenceMethod{
    NSArray *arr = @[@"1", @"2", @"3"];
    RACSequence *seq = [arr rac_sequence];
    
    /*
    seq = [seq map:^id _Nullable(id  _Nullable value) {
        return @([value intValue] * 3);
    }];
    NSLog(@"%@", [seq array]);
    */
    
    /*
    seq = [seq filter:^BOOL(id  _Nullable value) {
        return [value intValue] % 2 == 1;
    }];
    NSLog(@"%@", [seq array]);
    */
    
    
    
}

@end
