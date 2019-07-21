//
//  LoginViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/16.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveObjC.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RACSignal *signal = [[RACSignal combineLatest:@[_nameTF.rac_textSignal, _pwdTF.rac_textSignal]]map:^id _Nullable(RACTuple * _Nullable value) {
        
        return @([value[0]length] > 0 && [value[1]length] > 6);
    }];
    
    RACCommand *command = [[RACCommand alloc]initWithEnabled:signal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"clicked");
            [subscriber sendNext:@"next"];
            [subscriber sendCompleted];
            NSError *error = [[NSError alloc]initWithDomain:@"error" code:1000 userInfo:nil];
            [subscriber sendError:error];
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
        
        return signal;
    }];
                 
    [self.login setRac_command:command];
    
    [self.login.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"next = ");
        }];
    }];
    
    [self.login.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeCompleted:^{
            NSLog(@"complete = ");
        }];
    }];
    
    [self.login.rac_command.executionSignals subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeError:^(NSError * _Nullable error) {
            NSLog(@"error = ");
        }];
    }];
    
    
}



@end
