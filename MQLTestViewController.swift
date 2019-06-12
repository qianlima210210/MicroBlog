//
//  MQLTestViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/31.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import Alamofire

class MQLTestViewController: MQLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }
    
    @objc func titleBtnClicked(sender: UIBarButtonItem) -> () {
        print(#function)
        let vc = MQLTestViewController()
        
        let count = navigationController?.children.count ?? 0
        vc.title = "\(count)"

        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func generalInit() -> () {
        let n0 = NetworkRequestEngine.share
        //https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.002SUK3C_5a2KB590f93dd00DxZ3yD
        n0.accessTokenRequest("https://api.weibo.com/2/statuses/home_timeline.json") { (value, error) in
            
            if error == nil && value != nil {
                let error_code = value!["error_code"] as? Int ?? 0
                if error_code == 0 {
                    //成功获取正常数据
                    
                }else{
                   //成功获取异常数据
                    
                }
            }else{
                //网络出错
            }
            
        }

    }
    
}

extension MQLTestViewController {
    
    override func setTableView() {
        super.setTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "next", target: self, action: #selector(titleBtnClicked(sender:)))
    }
}




