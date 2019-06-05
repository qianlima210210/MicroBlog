//
//  MQLMainTabBarController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLMainTabBarController: MQLBaseTabBarController {
    
    //添加到tabBar上的撰写按钮
    private var composeBtn: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
        
    }
    
    private func generalInit() ->() {
        
        specialSettingToTabBar()
        setupChildControllers()
        setupComposeBtn()
    }
    
    @objc private func composeBtnClicked(sender: UIButton) -> () {
        print(#function)
    }
    
}


extension MQLMainTabBarController {
    
    //MARK: 对tabBar特定设置
    private func specialSettingToTabBar() -> () {
        //去掉顶部线条
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        //为tabBar添加阴影
        tabBar.layer.backgroundColor = UIColor.white.cgColor
        tabBar.layer.shadowColor = UIColor.blue.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 1
    }
    
    //MARK: 设置子控制器
    private func setupChildControllers() -> () {
        
        let itemArray: Array<Dictionary<String, Any>> = [
            ["className":("MQLHomeViewController"), "title":"首页", "image":"tabbar_home", "selectedImage":"tabbar_home_selected", "visitorInfo":["imageName":"", "message":"网易是中国领先的互联网技术公司，为用户提供免费邮箱、游戏、搜索引擎服务，开设新闻、娱乐"]
            ],
            ["className":("MQLMessageViewController"), "title":"消息", "image":"tabbar_message_center", "selectedImage":"tabbar_message_center_selected", "visitorInfo":["imageName":"visitordiscover_image_message", "message":"63贵州人事考试信息网发布最新最全最好的贵州人事考试信息 公务员 事业单位 人才招聘等"]
            ],
            ["className":("")],
            ["className":("MQLDiscoverViewController"), "title":"发现", "image":"tabbar_discover", "selectedImage":"tabbar_discover_selected", "visitorInfo":["imageName":"visitordiscover_image_message", "message":"新闻,新闻中心,包含有时政新闻,国内新闻,国际新闻,社会新闻,时事评"]
            ],
            ["className":("MQLProfileViewController"), "title":"个人", "image":"tabbar_profile", "selectedImage":"tabbar_profile_selected", "visitorInfo":["imageName":"visitordiscover_image_profile", "message":"凯恩之角是暗黑破坏神3官方合作中文网站,提供暗黑破坏神3下载"]
            ]
        ]
        
        //(itemArray as NSArray).write(toFile: "/Users/maqianli/Desktop/default.plist", atomically: true)
        
        var arrayM = Array<UIViewController>()
        for item in itemArray {
            let vc = controller(item)
            arrayM.append(vc)
        }
        
        viewControllers = arrayM
    }
    
    private func controller(_ item: Dictionary<String, Any>) -> UIViewController {
        
        guard let nameSpace = Bundle.main.nameSpace,
            let className = item["className"] as? String,
            let title = item["title"] as? String,
            let image = item["image"] as? String,
            let selectedImage = item["selectedImage"] as? String,
            let visitorInfo = item["visitorInfo"] as? [String : String],
            let cls = NSClassFromString("\(nameSpace).\(className)") as? UIViewController.Type,
            let normal = UIImage(named: image)?.withRenderingMode(.alwaysOriginal),
            let selected = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal) else {
                
            let vc = UIViewController()
            return MQLBaseNavigationController(rootViewController: vc)
        }
        
        let vc = cls.init(nibName: className, bundle: nil) as! MQLBaseViewController
        vc.visitorView.visitorInfo = visitorInfo
        vc.title = title
        vc.tabBarItem = UITabBarItem(title: title, image: normal, selectedImage: selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.orange], for: .selected)
        
        let nav = MQLBaseNavigationController(rootViewController: vc)
        
        
        return nav
    }
    
    private func setupComposeBtn() -> () {
        composeBtn.addTarget(self, action: #selector(composeBtnClicked(sender:)), for: .touchUpInside)
        tabBar.addSubview(composeBtn)
        
        let count = CGFloat(viewControllers?.count ?? 0)
        let w = tabBar.bounds.width / count
        
        //防止点击穿透
        composeBtn.frame = tabBar.bounds.inset(by: UIEdgeInsets(top: 0, left: 2 * w - 1, bottom: 0, right: 2 * w - 1))
    }
}
