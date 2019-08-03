//
//  ContactViewController.m
//  WeChat
//
//  Created by ma qianli on 2018/7/28.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, XMPPRosterDelegate, XMPPvCardAvatarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *contactFetchedResultsController;

@property (nonatomic, strong) NSArray *contactArray;


@end


@implementation ContactViewController

- (void)setContactArray:(NSArray *)contactArray{
    _contactArray = contactArray;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [[StreamManager sharedManager].vCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //获取好友数据
    [self.contactFetchedResultsController performFetch:nil];
    self.contactArray = self.contactFetchedResultsController.fetchedObjects;
    
}

-(void)setNavigationBar{
    self.title = @"好友";
    //单独设置标题，也可以统一设置标题
    self.navigationController.navigationBar.titleTextAttributes=
  @{NSForegroundColorAttributeName:[UIColor blackColor],
    NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    
    [[StreamManager sharedManager].roster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
}

-(void)addFriend{
    XMPPJID *jid = [XMPPJID jidWithUser:@"lisi" domain:@"127.0.0.1" resource:nil];
    [[StreamManager sharedManager].roster addUser:jid withNickname:@"昵称"];
}

- (NSFetchedResultsController *)contactFetchedResultsController{
    if (_contactFetchedResultsController == nil) {
        //创建获取请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        //实体
        fetchRequest.entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        
        //谓词
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subscription = %@", @"both"];
        
        //排序
        NSSortDescriptor *sort =[NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
        fetchRequest.sortDescriptors = @[sort];
        
        _contactFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"contacts"];
        
        _contactFetchedResultsController.delegate = self;
    }
    return _contactFetchedResultsController;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    XMPPUserCoreDataStorageObject *obj = _contactArray[indexPath.row];
    cell.textLabel.text = obj.jidStr;
    
    NSData *photo = [[StreamManager sharedManager].vCardAvatarModule photoDataForJID:obj.jid];
    cell.imageView.image = [UIImage imageWithData:photo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChatViewController *vc = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    
    XMPPUserCoreDataStorageObject *obj = _contactArray[indexPath.row];
    vc.chatJID = obj.jid;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *obj = _contactArray[indexPath.row];
        [[StreamManager sharedManager].roster removeUser:obj.jid];
    }
}

#pragma mark -- NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //fetchedResults有变化
    self.contactArray = self.contactFetchedResultsController.fetchedObjects;
}


#pragma mark -- XMPPRosterDelegate
/**
 * Sent when a presence subscription request is received.
 * That is, another user has added you to their roster,
 * and is requesting permission to receive presence broadcasts that you send.
 *
 * The entire presence packet is provided for proper extensibility.
 * You can use [presence from] to get the JID of the user who sent the request.
 *
 * The methods acceptPresenceSubscriptionRequestFrom: and rejectPresenceSubscriptionRequestFrom: can
 * be used to respond to the request.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    XMPPJID *from =[presence from];
    //收到对方接受请求的回应请求
    [[StreamManager sharedManager].roster acceptPresenceSubscriptionRequestFrom:from andAddToRoster:YES];
}

#pragma mark -- XMPPvCardAvatarDelegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid{
    [self.tableView reloadData];
    
}

























@end
