//
//  RGBViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/16.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "RGBViewController.h"
#import <ReactiveObjC.h>

@interface RGBViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UITextField *redTF;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UITextField *greenTF;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *blueTF;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@end

@implementation RGBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _redTF.text = _greenTF.text = _blueTF.text = @"0.5";
    
    RACSignal *redSignal = [self blindSlider:_redSlider textField:_redTF];
    RACSignal *greenSignal = [self blindSlider:_greenSlider textField:_greenTF];
    RACSignal *blueSignal =[self blindSlider:_blueSlider textField:_blueTF];
    
    [[[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]]map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }] subscribeNext:^(id  _Nullable x) {
        self.resultView.backgroundColor = x;
    }];
    
    
}

- (RACSignal*)blindSlider:(UISlider*)slider textField:(UITextField*)textField{
    RACSignal *textSignal = [[textField rac_textSignal]take:1];
    
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalTextField = [textField rac_newTextChannel];
    
    //signalTextField为自己添加一个订阅者(记住，只有订阅者sendNext、sendComplete、sendError)
    //signalTextField该信号对象在textField中text发生变化时，会调用其持有的订阅者发送next...
    [signalTextField subscribe:signalSlider];
    
    RACSignal *signal = [signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%f", [value doubleValue]];
    }];
    [signal subscribe:signalTextField];
    
    return [[signalSlider merge:signalTextField]merge:textSignal];

}

@end
