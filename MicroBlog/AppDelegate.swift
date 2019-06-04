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
        
        
        
        return true
    }

    

}

