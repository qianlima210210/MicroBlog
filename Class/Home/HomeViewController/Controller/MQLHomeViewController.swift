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
    private var viewModel: MQLHomeViewModel = MQLHomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }
    
    @objc func leftBtnClicked(sender: UIBarButtonItem) -> () {
        print(#function)
        let vc = MQLTestViewController()
        let count = navigationController?.children.count ?? 0
        vc.title = "\(count)"
        navigationController?.pushViewController(vc, animated: true)
    }
    

    func generalInit() -> () {
        let btn: UIButton = UIButton.cz_textButton("good", fontSize: 16, normalColor: .black, highlightedColor: .black)
        
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        
        btn.addTarget(self, action: #selector(titleBtnClicked(sender:)), for: .touchUpInside)
        
        navItem.titleView = btn
    }
    
    @objc func titleBtnClicked(sender:UIButton) -> () {
        sender.isSelected = !sender.isSelected
    }
    
    override func loadData(isPullUp: Bool) {
        
        getStatuses(isPullUp: isPullUp) { (value, errr) in
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }

}

extension MQLHomeViewController {
    
    override func setTableView() {
        super.setTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(leftBtnClicked(sender:)))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func getStatuses(isPullUp: Bool, completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> (){
        
        if MQLUserAccountManager.share.userLogon == false {
            completionHandler(nil, NSError(domain: "未登录", code: -1, userInfo: nil))
            return
        }
        
        viewModel.getStatuses(isPullUp: isPullUp) { (value, error) in
            completionHandler(value, error)
        }
        
    }
    
}

//落地实现UITableViewDataSource, UITableViewDelegate
extension MQLHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.dataModel.statuses.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        //设置
        let status = viewModel.dataModel.statuses[indexPath.row]
        cell.textLabel?.text = status.text
        
        //返回
        return cell
    }
}


