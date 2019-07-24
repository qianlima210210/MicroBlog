//
//  ContentView.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/18.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "ContentView.h"


@interface ContentView ()


@property (nonatomic, strong) UIButton *btn;

@end

@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.orangeColor;
        
        _btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
        [self addSubview:_btn];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            NSLog(@"clicked");
            [self.subject sendNext:@"你收到了吗？"];
            [self.subject sendCompleted];//sendCompleted调用后，subject将失效，需要重新创建。
            //[self sendValue:@"value" dic:@{@"name":@"RAC", @"age":@12}];
            
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationName" object:@{@"name":@"RAC", @"age":@12}];
        }];
    }
    return self;
}

- (void)sendValue:(NSString*)value dic:(NSDictionary*)dic{
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _btn.center = self.center;
}

- (RACSubject *)subject{
    if (_subject == nil) {
        _subject = [RACSubject subject];
    }
    
    return _subject;
}


@end
