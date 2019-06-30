//
//  MQLComposeViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/30.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeViewController: MQLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        generalInit()
    }


}

extension MQLComposeViewController {
    
    func generalInit() {
        
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "back", target: self, action: #selector(backBtnClicked))
        
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", target: self, action: #selector(backBtnClicked), isBack:true)
    }
    
    @objc func backBtnClicked() -> () {
        dismiss(animated: true, completion: nil)
    }
}
