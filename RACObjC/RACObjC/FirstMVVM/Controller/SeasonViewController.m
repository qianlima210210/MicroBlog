//
//  SeasonViewController.m
//  RACObjC
//
//  Created by ma qianli on 2019/7/23.
//  Copyright © 2019 qianli. All rights reserved.
//

#import "SeasonViewController.h"
#import <MBProgressHUD.h>

@interface SeasonViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *send;

@end

@implementation SeasonViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [JRBaseViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self bindViewModel];
}

-(void)bindViewModel{
    @weakify(self)
    //1.
    [[RACObserve(_viewModel, requestStatus) skip:1] subscribeNext:^(NSNumber* x) {
        @strongify(self)
        switch ([x intValue]) {
            case HTTPRequestStatusBegin:
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                break;
            case HTTPRequestStatusEnd:
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                break;
            case HTTPRequestStatusError:
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                break;
        }
    }];
    
    //2.
    [[_send rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self.viewModel.subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
        } error:^(NSError * _Nullable error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.description;
            [hud hideAnimated:YES afterDelay:3.f];
        } completed:^{
            
        }];
        
        //execute触发SignalBlock的调用
        [self.viewModel.requestCommand execute:@"96671e1a812e46dfa4264b9b39f3e225"];
    }];
}


@end
