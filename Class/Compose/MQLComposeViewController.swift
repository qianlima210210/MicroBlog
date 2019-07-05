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
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", target: self, action: #selector(backBtnClicked), isBack:true)
        addMQLComposeViewContent()
    }
    
    @objc func backBtnClicked() -> () {
        dismiss(animated: true, completion: nil)
    }
    
    override func setTableView() {
        
    }
    
    func addMQLComposeViewContent() -> () {
        guard let composeViewContent = MQLComposeViewContent.composeViewContent() else {
            return
        }
        
        contentView.addSubview(composeViewContent)
        composeViewContent.snp_makeConstraints({ (make) in
            make.left.right.bottom.top.equalToSuperview()
        })
    }
}


