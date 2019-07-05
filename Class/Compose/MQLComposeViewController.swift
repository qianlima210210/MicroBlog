//
//  MQLComposeViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/30.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeViewController: MQLBaseViewController {
    
    
    @IBOutlet var titleView: UILabel!
    
    lazy var sendButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("发布", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        
        btn.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }
}

//UI相关
extension MQLComposeViewController {
    
    func generalInit() {
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", target: self, action: #selector(backBtnClicked), isBack:true)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        navItem.titleView = titleView
        
        sendButton.isEnabled = false
        
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


