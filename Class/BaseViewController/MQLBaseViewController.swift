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
    
    //未登录显示游客视图
    var visitorView: MQLVisitorView = (Bundle.main.loadNibNamed("MQLVisitorView", owner: nil, options: nil)?.last as? MQLVisitorView) ?? MQLVisitorView()
    
    //登录后显示表格
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    //出去导航和tabBar标签后，中间内容区域
    var contentView: UIView = UIView(frame: CGRect.zero)
    
    //自定义导航条
    lazy var navigtionBar: MQLNavigationBar = MQLNavigationBar(frame: CGRect(x: 0,
                                                                           y: 0,
                                                                           width: UIScreen.cz_screenWidth(),
    height: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.bounds.height ?? 0)))
    
    //自定义导航条目
    lazy var navItem: UINavigationItem = UINavigationItem()
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerNotifications()
        setupUI()
        
    }
    
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    
    /// 加载数据
    func loadData(isPullUp: Bool) -> () {
        //基类无任何加载
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
    
    //注册通知
    func registerNotifications() -> () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveNotificationOfLoginSuccess(notification:)), name: NSNotification.Name(notificationOfLoginSuccess), object: nil)
    }
    
    @objc func onReceiveNotificationOfLoginSuccess(notification: NSNotification) -> () {
        view = nil
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
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

//UI相关的扩展
extension MQLBaseViewController {
    
    /// 设置UI
    private func setupUI() -> () {
        
        view.backgroundColor = UIColor.white
        
        //添加自定义导航栏
        specialSettingToNavigtionBar()
        
        //添加中间内容视图
        setContentView()
        
        /// 设置表格视图
        MQLUserAccountManager.share.userLogon ? setTableView() : setVisitorView()
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
        navigtionBar.tintColor = .orange
        //设置标题文字颜色、字体大小
        navigtionBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        
        view.addSubview(navigtionBar)
    }
    
    //添加中间内容视图
    private func setContentView() ->() {
        view.addSubview(contentView)
        
        //tabBar有效且height大于0（83和49）时，判断是带有tabBar的rootVC, 还是没带tabBar的rootVC，
        //带的话contentView的底部间距为（83）或（49）
        //不带的话contentView的底部间距为（83-49）或（49-49）
        //tabBar为nil时,
        
        var height: CGFloat = 0.0
        if tabBarController?.tabBar != nil {
            height = (tabBarController?.tabBar.bounds.height)!
            
            if (tabBarController?.selectedViewController?.children.count ?? 0) > 1 {
                height = (height > 49) ? (height - 49) : 0
            }
        }else{
            height = 0
            if UIApplication.shared.statusBarFrame.height == 44 {
                height = 44
            }
        }
        
        contentView.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(navigtionBar.snp_bottom).offset(0)
            make.bottom.equalTo(view.snp_bottom).offset(-height)
        }
    }
    
    /// 设置表格视图
   @objc func setTableView() -> () {
        tableView.dataSource = self
        tableView.delegate = self
        contentView.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left).offset(0)
            make.top.equalTo(contentView.snp_top).offset(0)
            make.right.equalTo(contentView.snp_right).offset(0)
            make.bottom.equalTo(contentView.snp_bottom).offset(0)
        }
        
        addMJRefreshControl()
    }
    
    
    /// 添加MJ刷新控件
    private func addMJRefreshControl() -> () {
        //创建头
        let header = MJRefreshNormalHeader {
            if self.tableView.mj_footer.state != .idle {
                //自己结束
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            self.loadData(isPullUp: false)
        }
        //隐藏时间
        header?.lastUpdatedTimeLabel.isHidden = true
        //自动进入刷新
        header?.beginRefreshing()
        //设置头
        tableView.mj_header = header
        
        //创建脚
        let footer = MJRefreshAutoNormalFooter {
            if self.tableView.mj_header.state != .idle {
                //自己结束
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            self.loadData(isPullUp: true)
        }
        // 当上拉刷新控件出现10%时，就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
        footer?.triggerAutomaticallyRefreshPercent = 0.1
        
        //设置脚
        tableView.mj_footer = footer
        
    }
    
    //设置
    @objc func setVisitorView() -> () {
        contentView.addSubview(visitorView)
        
        visitorView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(contentView.snp_left).offset(20)
            make.right.equalTo(contentView.snp_right).offset(-20)
            make.height.equalTo(300)
        }
        
        //添加登录、注册响应
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClicked), for: .touchUpInside)
        
        //设置左右导航项
        navItem.leftBarButtonItem = UIBarButtonItem(title: "登录", target: self, action: #selector(loginBtnClicked))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClicked))

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
        let maxVisualHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height

        if contentHeight < maxVisualHeight {
            tableView.mj_footer.isHidden = true
        }else{
            tableView.mj_footer.isHidden = false
        }

    }
    
}

//MARK:登录、注册响应
extension MQLBaseViewController {
    @objc func loginBtnClicked() -> () {
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationOfUserLogin), object: nil, userInfo: nil)
    }
    
    @objc func registerBtnClicked() -> () {
        print(#function)
    }
}









