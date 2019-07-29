//
//  ViewController.m
//  Camera
//
//  Created by maqianli on 2019/7/29.
//  Copyright © 2019 onesmart. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraContainerView;
@property (strong, nonatomic) UIImagePickerController *controller;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_controller == nil) {
        [self configImagePickerController];
        [self.view bringSubviewToFront:_cameraContainerView];
    }
    
}

//拍照
- (IBAction)take:(id)sender {
    [_controller takePicture];//会触发didFinishPickingMediaWithInfo回调
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self isCameraIsAvailable]) {
        NSLog(@"照相机可用");
    }else{
        NSLog(@"照相机不可用");
    }
    
    if ([self isCameraFlashAvailableFront]) {
        NSLog(@"闪光灯对前置照相机可用");
    }else{
        NSLog(@"闪光灯对前置照相机不可用");
    }
    
    if ([self isCameraAvailableFront]) {
        NSLog(@"前置照相机可用");
    }else{
        NSLog(@"前置照相机不可用");
    }
    
    if ([self isCameraAvailableRear]) {
        NSLog(@"后置照相机可用");
    }else{
        NSLog(@"后置照相机不可用");
    }
    
    //public.image/public.movie
    if ([self isCameraSuppotType:@"public.movie"]) {
        NSLog(@"照相机可以录制");
    }else{
        NSLog(@"照相机不可以录制");
    }
    
    if ([self isCameraSuppotType:@"public.image"]) {
        NSLog(@"照相机可以拍照");
    }else{
        NSLog(@"照相机不可以拍照 ");
    }
    
    //照相机授权判断
    [self authCaptureDevice];
    
    //照片授权判断
    [self authorizationPhotoLibrary];
}

//配置UIImagePickerController
- (void)configImagePickerController{
    _controller = [[UIImagePickerController alloc]init];
    _controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    _controller.mediaTypes = @[/*@"public.movie",*/ @"public.image"];
    _controller.allowsEditing = NO;
    _controller.delegate = self;
    _controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    _controller.showsCameraControls = NO;
    
    //[self.navigationController presentViewController:_controller animated:YES completion:nil];
    [_cameraContainerView addSubview:_controller.view];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _controller.view.frame = _cameraContainerView.bounds;
}

//照相机是否可用
- (BOOL)isCameraIsAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//闪光灯对前置照相机是否可用
- (BOOL)isCameraFlashAvailableFront{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront];
}

//闪光灯对后置照相机是否可用
- (BOOL)isCameraFlashAvailableRear{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

//前置照相机是否可用
- (BOOL)isCameraAvailableFront{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

//后置照相机是否可用
- (BOOL)isCameraAvailableRear{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//照相机是否支持拍照/录制
- (BOOL)isCameraSuppotType:(NSString*)type{
    NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    for (NSString *item in array) {
        if ([item compare:type] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

//照片授权判断
- (void)authorizationPhotoLibrary{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请去-> [设置 - 隐私 - 相机 - 项目名称] 打开访问开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alertView show];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                // 放一些使用相册的代码
            }
        }];
    }
}

//照相机授权判断
- (void)authCaptureDevice{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相机");
            return;
        } else if (authStatus == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请去-> [设置 - 隐私 - 相机 - 项目名称] 打开访问开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            [alertView show];
            return;
        } else if (authStatus == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机

        } else if (authStatus == AVAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    // 用户接受
                }
            }];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到您的摄像头, 请在真机上测试" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
    
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 系统是否大于10
        NSURL *url = nil;
        if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
            url = [NSURL URLWithString:@"prefs:root=privacy"];
            
        } else {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        [[UIApplication sharedApplication] openURL:url];
    }
}


//MARK: UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        _imageView.image = image;
        [self.view bringSubviewToFront:_imageView];
        
        //存到图片库
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [_controller.view removeFromSuperview];
    _controller = nil;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [_controller.view removeFromSuperview];
    _controller = nil;
}

@end
