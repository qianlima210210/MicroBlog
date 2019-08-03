//
//  ChatViewController.m
//  WeChat
//
//  Created by ma qianli on 2018/7/29.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSFetchedResultsController *msgFetchedResultsController;
@property (nonatomic, strong) NSMutableArray *msgArray;

@property (nonatomic, weak) XMPPvCardTemp *vCardTemp;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
    UINib *leftNib = [UINib nibWithNibName:@"LeftTableViewCell" bundle:nil];
    UINib *rightNib = [UINib nibWithNibName:@"RightTableViewCell" bundle:nil];
    
    [self.tableView registerNib:leftNib forCellReuseIdentifier:@"LeftTableViewCell"];
    [self.tableView registerNib:rightNib forCellReuseIdentifier:@"RightTableViewCell"];
    
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //获取聊天数据
    if ([self.msgFetchedResultsController performFetch:nil]) {
        [self fetchedResults:self.msgFetchedResultsController.fetchedObjects];
    }else{
        NSLog(@"performFetch error");
    }
    
}

-(void)setNavigationBar{
    self.title = @"聊天";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelKeyboard)];
    
}

-(void)cancelKeyboard{
    if (self.textView.isFirstResponder) {
        //[self.textView resignFirstResponder];
        //或者使用
        [self.textView endEditing:YES];
    }
}

-(void)transformView:(NSNotification *)aNSNotification
{
    CGFloat duration = [aNSNotification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyBoardEndBounds CGRectValue];
    
    CGFloat y = endRect.origin.y;
    CGFloat height = endRect.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (y == screenHeight) {//说明隐藏了
        self.textViewBottomConstraint.constant = 0.0f;
    }else{//说明弹出了
        self.textViewBottomConstraint.constant = height;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    //滚到最后
    [self scrollToBottom];
}

- (NSFetchedResultsController *)msgFetchedResultsController{
    // 推荐写法，减少嵌套的层次
    if (_msgFetchedResultsController == nil) {
        // 先确定需要用到哪个实体
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
        
        // 排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        request.sortDescriptors = @[sort];
        
        // 每一个聊天界面，只关心聊天对象的消息
        request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.chatJID.bare];
        
        // 得到上下文
        NSManagedObjectContext *ctx = [XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext;
        
        // 实例化，里面要填上上面的各种参数
        _msgFetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:@"timestamp" cacheName:nil];
        _msgFetchedResultsController.delegate = self;
    }
    
    return _msgFetchedResultsController;
}

- (NSMutableArray *)msgArray{
    if (_msgArray == nil) {
        _msgArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _msgArray;
}

- (XMPPvCardTemp *)vCardTemp{
    if (_vCardTemp == nil) {
        _vCardTemp = [StreamManager sharedManager].vCardTempModule.myvCardTemp;
    }
    return _vCardTemp;
}

-(void)fetchedResults:(NSArray*)results{
    
    if (results.count > 0) {
        [self.msgArray removeAllObjects];
        [results enumerateObjectsUsingBlock:^(XMPPMessageArchiving_Message_CoreDataObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.body != nil) {
                [self.msgArray addObject:obj];
                NSLog(@"from:%@, body=%@", obj.bareJidStr, obj.body);
            }
        }];
        
        [self.tableView reloadData];
        
        //滚到最后
        [self scrollToBottom];
    }
}
//滚到最后
-(void)scrollToBottom{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.msgFetchedResultsController.sections.count > 0) {
            /*
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgArray.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             */
            id<NSFetchedResultsSectionInfo> sectionInfo = self.msgFetchedResultsController.sections[self.msgFetchedResultsController.sections.count - 1];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionInfo.numberOfObjects - 1 inSection:self.msgFetchedResultsController.sections.count - 1];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}


#pragma mark - ******************** 发送消息方法
/** 发送信息 */
- (void)sendMessage:(NSString *)message
{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.chatJID];
    
    [msg addBody:message];
    [[StreamManager sharedManager].xmppStream sendElement:msg];
}


#pragma mark -- NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //fetchedResults有变化
    [self fetchedResults:self.msgFetchedResultsController.fetchedObjects];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self cancelKeyboard];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.msgFetchedResultsController.sections count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"titleForHeaderInSection";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.msgArray.count;
    id<NSFetchedResultsSectionInfo> sectionInfo = self.msgFetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    XMPPMessageArchiving_Message_CoreDataObject *obj = self.msgArray[indexPath.row];
     */
    
    XMPPMessageArchiving_Message_CoreDataObject *obj = [self.msgFetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *ID = (obj.isOutgoing == YES) ? @"RightTableViewCell" : @"LeftTableViewCell" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    NSString *msg = [[obj.body stringByAppendingString:@"\n"]stringByAppendingString:obj.timestamp.description];
    [cell setValue:msg forKeyPath:@"msgLab.text"];
    
    if (!obj.isOutgoing) {
        [cell setValue:[UIImage imageWithData:self.vCardTemp.photo] forKeyPath:@"header.image"];
    }else{
        NSData *photo = [[StreamManager sharedManager].vCardAvatarModule photoDataForJID:obj.bareJid];
        [cell setValue:[UIImage imageWithData:photo] forKeyPath:@"header.image"];
    }
    
    return cell;
    
}

#pragma mark -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 判断按下的是不是回车键。
    if ([text isEqualToString:@"\n"]) {
        
        // 自定义的信息发送方法，传入字符串直接发出去。
        [self sendMessage:textView.text];
        
        self.textView.text = nil;
        
        return NO;
    }
    return YES;
}


@end
