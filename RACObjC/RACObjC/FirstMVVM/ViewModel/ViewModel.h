//
//  ViewModel.h
//  RACObjC
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

@interface ViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestData;
@property(nonatomic, assign) HTTPRequestStatus requestStatus;

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSError* error;


@property (nonatomic, strong) DataModel *dataModel;



@end

