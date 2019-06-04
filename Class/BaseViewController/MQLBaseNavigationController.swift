//
//  MQLBaseNavigationController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.isHidden = true
    }
    
    //MARK: 屏幕旋转相关
    override var shouldAutorotate: Bool{
        if let topViewController = topViewController {
            return topViewController.shouldAutorotate
        }
        
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if let topViewController = topViewController {
            return topViewController.supportedInterfaceOrientations
        }
        
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        if let topViewController = topViewController {
            return topViewController.preferredInterfaceOrientationForPresentation
        }
        
        return .portrait
    }
    
    //MARK: 状态栏相关
    override var prefersStatusBarHidden: Bool{
        if let topViewController = topViewController {
            return topViewController.prefersStatusBarHidden
        }
        
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if let topViewController = topViewController {
            return topViewController.preferredStatusBarStyle
        }
        
        return .default
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            if let viewController = viewController as? MQLBaseViewController {
                
                var title = "返回"
                if children.count == 1 {
                    
                    if let first = children[0] as? MQLBaseViewController {
                        title = first.title ?? "返回"
                    }
                }
                viewController.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(backBtnClicked(sender:)), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func backBtnClicked(sender: UIBarButtonItem) -> () {
        popViewController(animated: true)
    }
}
