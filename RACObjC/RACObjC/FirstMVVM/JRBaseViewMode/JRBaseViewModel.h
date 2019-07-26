//
//  JRBaseViewModel.h
//
//  Created by ma qianli on 2019/7/23.
//  Copyright © 2019 qianli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "DataModel.h"

typedef NS_ENUM(NSUInteger, HTTPRequestStatus) {
    HTTPRequestStatusBegin,
    HTTPRequestStatusEnd,
    HTTPRequestStatusError,
};

@interface JRBaseViewModel : NSObject

@property(nonatomic, assign) HTTPRequestStatus requestStatus;       //请求状态
@property (nonatomic, strong) RACCommand *requestCommand;           //外部网络请求指令
@property (nonatomic, strong) RACSubject *subject;                  //用来向外部传递信息


@end

