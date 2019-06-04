//
//  MQLBaseTabBarController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: 屏幕旋转相关
    override var shouldAutorotate: Bool{
        if let selectedViewController = selectedViewController {
            return selectedViewController.shouldAutorotate
        }
        
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if let selectedViewController = selectedViewController {
            return selectedViewController.supportedInterfaceOrientations
        }
        
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        if let selectedViewController = selectedViewController {
            return selectedViewController.preferredInterfaceOrientationForPresentation
        }
        
        return .portrait
    }
    
    //MARK: 状态栏相关
    override var prefersStatusBarHidden: Bool{
        if let selectedViewController = selectedViewController {
            return selectedViewController.prefersStatusBarHidden
        }
        
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if let selectedViewController = selectedViewController {
            return selectedViewController.preferredStatusBarStyle
        }
        
        return .default
    }

}
