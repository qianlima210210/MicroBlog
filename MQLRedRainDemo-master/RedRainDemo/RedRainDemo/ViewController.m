//
//  ViewController.m
//  RedRainDemo
//
//  Created by ZTF on 16/10/13.
//  Copyright © 2016年 JiuXianTuan. All rights reserved.
//

#import "ViewController.h"

#define KSCReenWidth  [UIScreen mainScreen].bounds.size.width
#define KSCReenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) NSTimer  *timer;//---创建红包的定时器

@property (weak, nonatomic) IBOutlet UITextField *numberText;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;        //---红包选中的总个数
@property (weak, nonatomic) IBOutlet UILabel *selectedLabelBottom;  //---红包选中的总个数

@property (assign, nonatomic) double num;    //---多少个红包，即红包总数
@property (assign, nonatomic) double number;//---记录当前已经创建了多少个红包
@property (assign, nonatomic) NSInteger selectedNumber;//选中的红包
@property (weak, nonatomic) IBOutlet UIButton *stop;

@property (assign ,nonatomic) BOOL isStop;

//mql
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ViewController
#pragma mark - Filecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCustomView];
}
#pragma mark - CustomAccessors
- (void)configCustomView {
    [self.stop addTarget:self action:@selector(stopAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = UIColor.cyanColor;
    _contentView.hidden = YES;
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];
    
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-100];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[top, bottom, left, right]];
    
}

#pragma mark - Private
//开始红包雨
- (void)start {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.contentView.hidden = NO;
    
    self.isStop = NO;
    self.number = 0;
    self.selectedNumber = 0;
    [self.view endEditing:YES];
    if ([self.numberText.text doubleValue]) {
        self.num = [self.numberText.text doubleValue];
    }else {
        NSLog(@"-----不能为0或者字符");
        return;
    }
    self.startBtn.hidden = YES;
    self.selectedLabel.hidden = YES;
    double interval = 0.25;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(creatRedRain) userInfo:nil repeats:YES];
}
//结束
- (void)stopAnimation {
    self.contentView.hidden = YES;
    self.isStop = YES;
    [self.timer invalidate];
    self.timer = nil;

    self.selectedLabel.hidden = NO;
    self.selectedLabel.text = [NSString stringWithFormat:@"点中%ld个",self.selectedNumber];

    self.startBtn.hidden = NO;
}
//创建红包
- (void)creatRedRain {
    
    self.number++;//每创建一个红包增加一次,到固定次数后停止
    //second每个红包从创建到滚出屏幕的时间
    double second = 2;
    if (self.number > self.num) {
        [self.timer invalidate];
        self.timer = nil;
        //最后一个后,需要让最后一个到最下边后再完全停止
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentView.hidden = YES;
            self.startBtn.hidden = NO;
            self.selectedLabel.hidden = NO;
            self.selectedLabel.text = [NSString stringWithFormat:@"点中%ld个",self.selectedNumber];
        });
        return;
    }

    //NSLog(@"第%f个,间隔为%f,降落时间为%f",self.number,interval,second);
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hb.png"]];
    imageView.tag = self.number;
    [self animationWithImageView:imageView andSecond:second];

}
//开始动画
- (void)animationWithImageView:(UIImageView *)imageView andSecond:(double)second{
    //NSLog(@"tag=%ld",imageView.tag);
    int x = arc4random() % (int)([UIScreen mainScreen].bounds.size.width - 79);
    imageView.frame = CGRectMake(x, -95, 79, 95);
    [self.contentView addSubview:imageView];
    
    //下落动画
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)imageView.tag] context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:second];
    [UIView setAnimationDelegate:self];
    imageView.frame = CGRectMake(imageView.frame.origin.x, KSCReenHeight, imageView.frame.size.width, imageView.frame.size.height);
    [imageView setTransform:CGAffineTransformRotate(imageView.transform, M_PI * 0.2)];
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"rotationAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationRepeatAutoreverses:YES];
    CGAffineTransform tranform= CGAffineTransformMakeRotation(-M_PI * 0.2);
    [imageView setTransform:CGAffineTransformRotate(tranform, M_PI * 0.2)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

    
}
//动画停止
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    if (![animationID isEqualToString:@"rotationAnimation"]) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
        if (!imageView) {
            return;
        }
        [imageView.layer removeAllAnimations];
        [imageView removeFromSuperview];
        if (!self.isStop) {
        }
    }
}

//触摸view
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    NSLog(@"点了");
    CGPoint point = [touches.anyObject locationInView:self.contentView];
    
    for (UIImageView *imgView in self.contentView.subviews) {
        //便利显示的图片的layer,看触摸点在哪个里边
        if ([imgView.layer.presentationLayer hitTest:point]) {
            
            self.selectedNumber++;
            self.selectedLabelBottom.text = [NSString stringWithFormat:@"%ld",(long)self.selectedNumber];
            NSLog(@"点中了,第%ld个",(long)imgView.tag);
            [imgView.layer removeAllAnimations];
            imgView.center = point;
            if (!imgView) {
                return;
            }

            [self showAddCartAnmationSview:self.view imageView:imgView starPoin:imgView.center endPoint:CGPointMake(KSCReenWidth - 20 - 25, KSCReenHeight - 20 - 15) dismissTime:1.0];
            
            
            [imgView removeFromSuperview];
            return;
        }
    }
}

//点中后动画
- (void)showAddCartAnmationSview:(UIView *)sview
                       imageView:(UIImageView *)imageView
                        starPoin:(CGPoint)startPoint
                        endPoint:(CGPoint)endpoint
                     dismissTime:(float)dismissTime
{
    __block CALayer *layer;
    layer                               = [[CALayer alloc]init];
    layer.contents                      = imageView.layer.contents;
    layer.frame                         = imageView.frame;
    layer.opacity                       = 1;
    [sview.layer addSublayer:layer];
    UIBezierPath *path                  = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    //贝塞尔曲线控制点
    float sx                            = startPoint.x;
    float sy                            = startPoint.y;
    float ex                            = endpoint.x;
    float ey                            = endpoint.y;
    float x                             = sx + (ex - sx) / 3;
    float y                             = sy + (ey - sy) * 0.5 - 400;
    CGPoint centerPoint                 = CGPointMake(x, y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    //设置位置动画
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path                      = path.CGPath;
    animation.removedOnCompletion       = NO;
    //设置大小动画
    CGSize finalSize                    = CGSizeMake(imageView.image.size.height*0.1, imageView.image.size.width*0.1);
    CABasicAnimation *resizeAnimation   = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    resizeAnimation.removedOnCompletion = NO;
    [resizeAnimation setToValue:[NSValue valueWithCGSize:finalSize]];
    //旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation                   = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue           = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.cumulative        = YES;
    rotationAnimation.duration          = 0.3;
    rotationAnimation.repeatCount       = 1000;
    //动画组
    CAAnimationGroup * animationGroup   = [[CAAnimationGroup alloc] init];
    animationGroup.animations           = @[animation,resizeAnimation,rotationAnimation];
    animationGroup.delegate             = self;
    animationGroup.duration             = 0.6;
    animationGroup.removedOnCompletion  = NO;
    animationGroup.fillMode             = kCAFillModeForwards;
    animationGroup.autoreverses         = NO;
    animationGroup.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animationGroup forKey:@"buy"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dismissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
        layer = nil;
    });
}

@end
