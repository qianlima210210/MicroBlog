//
//  AppDelegate.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/25.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

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
        
        NetWorkTool.goToLogin(userName: "", password: "", completionHandler: { (_) in
            
        }, errorHandler: { (_) in
            
        }) { (_) in
            
        }
        
        return true
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
}

