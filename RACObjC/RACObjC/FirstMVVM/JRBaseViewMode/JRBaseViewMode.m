//
//  JRBaseViewModel.m
//
//  Created by ma qianli on 2019/7/23.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "JRBaseViewModel.h"

@implementation JRBaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initRequestCommand];
        [self subcribeCommandSignals];
    }
    return self;
}

- (RACSubject *)subject{
    if (_subject == nil) {
        _subject = [RACSubject subject];
    }
    
    return _subject;
}


/**
 订购外层、内层信号事件
 */
- (void)subcribeCommandSignals {
    @weakify(self)
    // 1. 订阅外层信号事件
    [self.requestCommand.executionSignals subscribeNext:^(RACSignal* innerSignal) {
        @strongify(self)
        // 2. 订阅内层信号事件
        [innerSignal subscribeNext:^(NSData *x) {
            //修改请求状态
            self.requestStatus = HTTPRequestStatusEnd;
            
            //发送subject事件订购事件信息
            [self.subject sendNext:x];
            [self.subject sendCompleted];
            self.subject = nil;
            
        }];
        
        //修改请求状态
        self.requestStatus = HTTPRequestStatusBegin;
    }];
    // 3. 订阅 errors 信号事件
    [self.requestCommand.errors subscribeNext:^(NSError * _Nullable x) {

        @strongify(self)
        //修改请求状态
        self.requestStatus = HTTPRequestStatusError;
        
        //发送subject事件订购事件信息
        [self.subject sendError:x];
        self.subject = nil;
        
    }];
}


/**
 创建请求命令
 */
- (void)initRequestCommand {
    if (!_requestCommand) {
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
            @strongify(self);
            // 进行网络操作，同时将这个操作封装成信号 return
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [self postParams:params success:^(id  _Nonnull responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSError * _Nonnull error) {
                    [subscriber sendError:error];
                }];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
        }];
    }
}


- (void)postParams:(NSDictionary*)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:@"https://www.juren.cn/api/v1/common/dd/seasonlist"];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                success(data);
            }else{
                failure(error);
            }
        });
 
    }]resume];
    
}


@end
