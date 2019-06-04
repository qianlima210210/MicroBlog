//
//  MQLHomeViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLHomeViewController: MQLBaseViewController {
    
    private let cellId = "cellId"
    private lazy var statusList = [String]()

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
    
    func generalInit() -> () {
        
    }
    
    override func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for i in 0..<20 {
                self.statusList.insert(i.description, at: 0)
            }
            
            self.tableView.reloadData()
        }
    }

}

extension MQLHomeViewController {
    override func setupUI() {
        super.setupUI()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(titleBtnClicked(sender:)))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}

//落地实现UITableViewDataSource, UITableViewDelegate
extension MQLHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //设置
        cell.textLabel?.text = statusList[indexPath.row]
        
        //返回
        return cell
    }
}


