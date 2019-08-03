//
//  RecentlyViewController.m
//  WeChat
//
//  Created by ma qianli on 2018/8/1.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "RecentlyViewController.h"

@interface RecentlyViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, XMPPvCardAvatarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *recentlyFetchedResultsController;
@property (nonatomic, strong) NSArray *recentlyArray;

@end

@implementation RecentlyViewController

- (void)setRecentlyArray:(NSArray *)recentlyArray{
    _recentlyArray = recentlyArray;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最近";
    // Do any additional setup after loading the view from its nib.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(joinRoom)];
    
    [[StreamManager sharedManager].vCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //获取好友数据
    [self.recentlyFetchedResultsController performFetch:nil];
    self.recentlyArray = self.recentlyFetchedResultsController.fetchedObjects;
}

-(void)joinRoom{
    
}

- (NSFetchedResultsController *)recentlyFetchedResultsController{
    if (_recentlyFetchedResultsController == nil) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //实体即表名
        request.entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        
        //谓词
        
        //排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
        request.sortDescriptors = @[sort];
        
        _recentlyFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"recently"];
        
        _recentlyFetchedResultsController.delegate = self;
    }
    return _recentlyFetchedResultsController;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentlyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }

    XMPPMessageArchiving_Contact_CoreDataObject *obj = self.recentlyArray[indexPath.row];
    cell.textLabel.text = obj.bareJidStr;
    cell.detailTextLabel.text = obj.mostRecentMessageBody;
    
    NSData *photo = [[StreamManager sharedManager].vCardAvatarModule photoDataForJID:obj.bareJid];
    cell.imageView.image = [UIImage imageWithData:photo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ChatViewController *vc = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    
    XMPPMessageArchiving_Contact_CoreDataObject *obj = _recentlyArray[indexPath.row];
    vc.chatJID = obj.bareJid;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    self.recentlyArray = self.recentlyFetchedResultsController.fetchedObjects;
}

#pragma mark -- XMPPvCardAvatarDelegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid{
    [self.tableView reloadData];
    
}


@end
