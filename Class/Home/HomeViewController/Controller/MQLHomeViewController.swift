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
        let btn = TitleButton(title: MQLUserAccountManager.share.screen_name != nil ?  MQLUserAccountManager.share.screen_name! + " " : "首页")
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
        
        tableView.register(UINib(nibName: "StatusRetweetCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
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
        let count = viewModel.statusListViewModel.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //获取
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StatusCell
        
        //设置
        let statusViewModel = viewModel.statusListViewModel[indexPath.row]
        cell.setStatus(statusViewModel: statusViewModel)
        
        //返回
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusViewModel = viewModel.statusListViewModel[indexPath.row]
        return 64 + statusViewModel.heightOfZhengWen + 0
                    + statusViewModel.sizeOfPicturesViewContainer.height + 10
                        + statusViewModel.heightOfBottomToolBar
    }
}


