//
//  MQLBaseViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh


class MQLBaseViewController: UIViewController {
    
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    //自定义导航条
    lazy var navigtionBar: MQLNavigationBar = MQLNavigationBar(frame: CGRect(x: 0,
                                                                           y: 0,
                                                                           width: UIScreen.cz_screenWidth(),
    height: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.bounds.height ?? 0)))
    
    //自定义导航条目
    lazy var navItem: UINavigationItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    
    /// 加载数据
    func loadData() -> () {
        
    }
    
    //MARK: 屏幕旋转相关
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    //MARK: 状态栏相关
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }


}


extension MQLBaseViewController {
    
    /// 设置UI
    @objc func setupUI() -> () {
        
        view.backgroundColor = UIColor.white
        
        //添加自定义导航栏
        specialSettingToNavigtionBar()
        
        /// 设置表格视图
        setTableView()
    }
    
    
    /// 设置导航栏
    private func specialSettingToNavigtionBar() -> () {
        
        //去掉导航栏下面的下划线
        //navigtionBar.shadowImage = UIImage()
        //设置导航项
        navigtionBar.items = [navItem]
        //是否透明，设置false，在push过程中不会出现闪动
        navigtionBar.isTranslucent = false
        //设置导航背景颜色
        navigtionBar.barTintColor = .white
        //设置导航左右item文字颜色
        navigtionBar.tintColor = .yellow
        //设置标题文字颜色、字体大小
        navigtionBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        
        view.addSubview(navigtionBar)
    }
    
    
    /// 设置表格视图
    func setTableView() -> () {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        let height: CGFloat = tabBarController?.tabBar.bounds.height ?? 0
        
        tableView.snp_makeConstraints { (make) in
            make.left.equalTo(view.snp_left).offset(0)
            make.top.equalTo(navigtionBar.snp_bottom).offset(0)
            make.right.equalTo(view.snp_right).offset(0)
            make.bottom.equalTo(view.snp_bottom).offset(-height)
        }
        
        addMJRefreshControl()
    }
    
    
    /// 添加MJ刷新控件
    private func addMJRefreshControl() -> () {
        //创建头
        let header = MJRefreshNormalHeader {
            self.loadData()
        }
        //隐藏时间
        header?.lastUpdatedTimeLabel.isHidden = true
        //自动进入刷新
        header?.beginRefreshing()
        //设置头
        tableView.mj_header = header
        
        //创建脚
        let footer = MJRefreshAutoNormalFooter {
            self.loadData()
        }
        // 当上拉刷新控件出现10%时，就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
        footer?.triggerAutomaticallyRefreshPercent = 0.1
        
        //设置脚
        tableView.mj_footer = footer
        
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension MQLBaseViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: UIScrollViewDelegate
extension MQLBaseViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let maxHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        
        if contentHeight > maxHeight {
            tableView.mj_footer.isHidden = false
        }else{
            tableView.mj_footer.isHidden = true
        }
    }
}












