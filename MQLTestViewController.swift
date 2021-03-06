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


    }
    
}

extension MQLTestViewController {
    
    override func setTableView() {
        super.setTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "next", target: self, action: #selector(titleBtnClicked(sender:)))
    }
}




