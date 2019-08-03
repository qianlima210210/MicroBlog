//
//  AppDelegate.m
//  WeChat
//
//  Created by ma qianli on 2018/7/25.
//  Copyright © 2018年 ma qianli. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect frame = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc]initWithFrame:frame];
    _window.backgroundColor = UIColor.whiteColor;
    [_window makeKeyAndVisible];
    
    //添加根控制器
    [self addRootViewController];
    
    // Override point for customization after application launch.
    [self launchOptionsHandelWithOptions:launchOptions];
    [self registerLocalNotification];
    
    XMPPJID *jid = [XMPPJID jidWithUser:@"zhangsan" domain:@"127.0.0.1" resource:nil];
    [[StreamManager sharedManager]loginWithJid:jid withPwd:@"zhangsan"];
    

    return YES;
}

-(void)launchOptionsHandelWithOptions:(NSDictionary *)launchOptions{
    if (launchOptions) {
        UILocalNotification *no = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:no.alertBody delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)registerLocalNotification{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
}

-(void)addRootViewController{
    //单独设置标题，也可以统一设置标题
    [[UINavigationBar appearance]setBarTintColor:UIColor.redColor];
    [[UINavigationBar appearance]setTintColor:UIColor.yellowColor];
    [UINavigationBar appearance].titleTextAttributes =  @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    //单独设置标题，也可以统一设置标题
//    self.navigationController.navigationBar.titleTextAttributes=
//    @{NSForegroundColorAttributeName:[UIColor blackColor],
//      NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    //tab0
    ContactViewController *vc0 = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav0 = [[UINavigationController alloc]initWithRootViewController:vc0];
    
    UIImage *image0 = [[UIImage imageNamed:@"tab_home_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage0 = [[UIImage imageNamed:@"tab_home_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav0.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"好友" image:image0 selectedImage:selectedImage0];
    
    //tab1
    RecentlyViewController *vc1 = [[RecentlyViewController alloc]initWithNibName:@"RecentlyViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];

    UIImage *image1 = [[UIImage imageNamed:@"tab_marketing_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage1 = [[UIImage imageNamed:@"tab_marketing_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"最近" image:image1 selectedImage:selectedImage1];
    
    //tab2
    MeViewController *vc2 = [[MeViewController alloc]initWithNibName:@"MeViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    UIImage *image2 = [[UIImage imageNamed:@"tab_mine_dim"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage2 = [[UIImage imageNamed:@"tab_mine_light"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:image2 selectedImage:selectedImage2];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[nav0, nav1, nav2];
    
    //一、如果只是设置选中状态的字体颜色，使用 tintColor  就可以达到效果
    //tabBarController.tabBar.tintColor = [UIColor orangeColor];
    
    //二、但如果要将未选中状态和选中状态下的颜色都改变，可以使用 setTitleTextAttributes:<#(nullable NSDictionary<NSString *,id> *)#> forState:<#(UIControlState)#> 达到效果
    [nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    [nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
    
    //或者
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];

    
    _window.rootViewController = tabBarController;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"收到本地通知:%@", notification.alertBody);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
