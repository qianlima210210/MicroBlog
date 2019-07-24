//
//  ViewModel.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/23.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataModel = [DataModel new];
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

- (void)subcribeCommandSignals {
    @weakify(self)
    // 1. 订阅外层信号
    [self.requestData.executionSignals subscribeNext:^(RACSignal* innerSignal) {
        @strongify(self)
        // 2. 订阅内层信号
        [innerSignal subscribeNext:^(NSData *x) {
            [self.subject sendNext:x];
            [self.subject sendCompleted];
            self.subject = nil;
            self.requestStatus = HTTPRequestStatusEnd;
        }];

        self.requestStatus = HTTPRequestStatusBegin;
    }];
    // 3. 订阅 errors 信号
    [self.requestData.errors subscribeNext:^(NSError * _Nullable x) {

        @strongify(self)
        self.requestStatus = HTTPRequestStatusError; // 这一句必须放在最后一句，否者 controller 拿不到数据
        [self.subject sendError:x];
        self.subject = nil;
        
    }];
}

- (RACCommand *)requestData {
    if (!_requestData) {
        @weakify(self);
        _requestData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
            @strongify(self);
            // 进行网络操作，同时将这个操作封装成信号 return
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSString *url = @"https://www.juren.cn/api/v1/common/dd/seasonlist";
                [self postUrl:url params:params success:^(id  _Nonnull responseObject) {
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
    return _requestData;
}

- (void)postUrl:(NSString*)urlStr params:(NSDictionary*)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
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
