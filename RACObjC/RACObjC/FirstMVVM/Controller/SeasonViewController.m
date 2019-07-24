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


@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation SeasonViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewModel = [ViewModel new];
        _array = [NSMutableArray array];
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
    // 1.
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
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = self.viewModel.error.localizedDescription;
                [hud hideAnimated:YES afterDelay:3];
                
                break;
        }
    }];
    
    // 2.
    RAC(self.textView,text) = [[RACObserve(_viewModel, data) skip:1] map:^id _Nullable(NSDictionary* value) {
        return value.description;
    }];
    
    // 3.
    //    _button.rac_command = _viewModel.requestData;
    [[_send rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.requestData execute:@"96671e1a812e46dfa4264b9b39f3e225"];
    }];
    
    [[RACObserve(self.array, count) skip:1]subscribeNext:^(id  _Nullable x) {
        NSLog(@"count = %@", x);
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}



@end
