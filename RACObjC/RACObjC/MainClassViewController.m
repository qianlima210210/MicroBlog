//
//  MainClassViewController.m
//  RACObjC
//

#import "MainClassViewController.h"
#import <ReactiveObjC.h>

@interface MainClassViewController ()

@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, strong) RACSubject *subject;
@property (nonatomic, strong) RACReplaySubject *replaySubject;

@end

@implementation MainClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generailInit];
}

- (void)generailInit{
    [self initSignal];
}

/*--------------RACSignal-----------*/
- (void)initSignal{
    //创建信号
    //@weakify(self);
    _signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //@strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //订阅者发送事件
            [subscriber sendNext:@"next事件信息"];
        });
        
        RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
            NSLog(@"接收事件后的清理或取消订阅事件后的清理");
        }];
        return disposable;
    }];
}

- (IBAction)subscribSignalEvent:(id)sender {
    /* 订阅事件 */
    _disposable = [_signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收事件：%@", x);
    }];
}

- (IBAction)cancelSubscribSignalEvent:(id)sender {
    //取消订阅事件(取消后，就收不到next等事件了)
    [_disposable dispose];
}

/*--------------RACSignal-----------*/

/*--------------RACSubject-----------*/
- (void)sujectUse{
    //创建信号@interface RACSubject<ValueType> : RACSignal<ValueType> <RACSubscriber>
    //RACSubject一般用于发送next等事件，它既是信号也是订阅者
    if (_subject == nil) {
        _subject = [RACSubject subject];
        
        //订阅信号事件（通常在别的视图控制器中订阅，与代理的用法类似
        [_subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"第一个订阅者：%@", x);
        }];
        
        [_subject subscribeNext:^(id _Nullable x) {
            NSLog(@"第二个订阅者：%@",x);
        }];
    }
    
    //订阅者发送事件
    [_subject sendNext:@"next事件信息"];
}

/*--------------RACSubject-----------*/

/*--------------RACTuple-----------*/
- (void)tupleUse{
    //把值包装成元组
    RACTuple * tuple = RACTuplePack(@"abc",@"def",@"ghj",@1,@"2",@3,@NO);
    //解析元组
    //RACTupleUnpack(NSString *a , NSString *b , NSString *c) = tuple ;
    NSLog(@"RACTuple 元组包装: pack = %@ ",tuple);
}

- (void)emulateDicByTuple{
    //利用元组遍历字典
    NSDictionary * dic = @{@"name":@"Jakey" , @"age":@18 , @"student":@(YES)};
    
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
        NSString * key = [(RACTuple *)x objectAtIndex:0];
        id value = [(RACTuple *)x objectAtIndex:1];
        NSLog(@"NSDictionary第x个key-value元组 = %@ , key = %@ , value = %@ , thread = %@",x,key,value,[NSThread currentThread]);
    }completed:^{
        NSLog(@"NSDictionary 元组使用 completed , thread = %@",[NSThread currentThread]);
    } ];
    
}

- (void)emulateArrayByTuple{
    //利用元组遍历数组
    NSArray * array = @[@"klr",@"nop",@"rst"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"NSArray第x个元组 x = %@ , thread = %@",x,[NSThread currentThread]);
    }error:^(NSError * _Nullable error) {
        NSLog(@"NSArray 元组 error = %@",error);
    } completed:^{
        NSLog(@"NSArray 元组 completed ,thread = %@",[NSThread currentThread]);
    }];
    
}

- (void)mapUse{
    //map的使用
    
    NSArray * array = @[@"001",@"002",@"003"];
    RACSequence *sequence = [array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"value = %@ , thread = %@",value,[NSThread currentThread]);
        return [value stringByAppendingString:@" 学号"];
    }] ;
    
    
    NSLog(@"===== %@", [sequence array]);
}

/*--------------RACTuple-----------*/

/*--------------RACReplaySubject-----------*/
- (void)replaySubjectUse{
    //Capacity事先预指订阅的个数，里面是数组
    if (_replaySubject == nil) {
        _replaySubject = [RACReplaySubject replaySubjectWithCapacity:2];
    }
    
    
    //发送
    [_replaySubject sendNext:@"RACReplaySubjectDome 先发送 1"];
    [_replaySubject sendNext:@"RACReplaySubjectDome 先发送 2"];
    [_replaySubject sendCompleted];
    
    //订阅
    _disposable = [_replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext:x = %@ error completed , thread  = %@",x,[NSThread currentThread]);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error = %@ , thread = %@",error,[NSThread currentThread]);
    } completed:^{
        NSLog(@"completed ! , thread = %@",[NSThread currentThread]);
    }];
    
    //延时订阅，一样可以接收到信号
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.replaySubject subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"subscribeNext: x = %@, thread = %@",x,[NSThread currentThread]);
        }];
    });
}
/*--------------RACReplaySubject-----------*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


}

@end
