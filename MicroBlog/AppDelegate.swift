//
//  AppDelegate.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/25.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.backgroundColor = .white
        
        window?.rootViewController = MQLMainTabBarController()
        
        window?.makeKeyAndVisible()
        
        imitateAppInfoLoad()
        registerPush(application)
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate {
    
    /// 模拟网络加载
    func imitateAppInfoLoad() -> () {
        
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "default", withExtension: "json"),
                let data = try? Data.init(contentsOf: url),
                let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
                
                return;
            }
            
            let destPath = (docPath as NSString).appendingPathComponent("net.json")
            do {
                let destUrl = URL(fileURLWithPath: destPath)
                try data.write(to: destUrl)
            } catch {
                
            }
        }
    }
    
    func registerPush(_ application: UIApplication) -> () {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil))
            application.registerForRemoteNotifications()
        }
    }
}

