//
//  MeViewController.m
//  WeChat
//
//  Created by ma qianli on 2018/8/4.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XMPPvCardTempModuleDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) XMPPvCardTemp *vCardTemp;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我";
    [[StreamManager sharedManager].vCardTempModule addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
}

- (XMPPvCardTemp *)vCardTemp{
    if (_vCardTemp == nil) {
        _vCardTemp = [StreamManager sharedManager].vCardTempModule.myvCardTemp;
    }
    return _vCardTemp;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;//头像，名称，昵称，备注
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *touxiangreuse = @"touxiangreuse";
    static NSString *mingchengreuse = @"mingchengreuse";
    static NSString *nichengreuse = @"nichengreuse";
    static NSString *beizhureuse = @"beizhureuse";
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:touxiangreuse];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:touxiangreuse];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.imageView.image = [UIImage imageWithData:self.vCardTemp.photo];
            
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:mingchengreuse];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mingchengreuse];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = [StreamManager sharedManager].xmppStream.myJID.bare;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:nichengreuse];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nichengreuse];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = self.vCardTemp.nickname;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:beizhureuse];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:beizhureuse];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            //备注
            cell.textLabel.text = self.vCardTemp.desc;
            break;

        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.editing = YES;
    controller.delegate = self;
    
    [self.navigationController presentViewController:controller animated:YES completion:^{
        
    }];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"---");
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.vCardTemp.photo =  UIImageJPEGRepresentation(image, 0.2);
    [[StreamManager sharedManager].vCardTempModule updateMyvCardTemp:self.vCardTemp];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- XMPPvCardTempModuleDelegate

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    self.vCardTemp = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

@end
