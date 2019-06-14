//
//  MQLLoginViewController.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/14.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import WebKit

class MQLLoginViewController: UIViewController {
    
    
    @IBOutlet weak var webViewContainer: UIView!
    
    var viewModel = MQLLoginViewModel()
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }

    func generalInit() -> () {
        title = "登录"
        setupBarButtonItem()
        startWebView()
    }
    
    @objc func backBtnClicked(sender: UIBarButtonItem) -> () {
        dismiss(animated: true, completion: nil)
    }
    
    func setupBarButtonItem() -> () {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(backBtnClicked(sender:)), isBack: true)
    }
    
    func startWebView() -> () {
        
        webView.backgroundColor = .orange
        webViewContainer.addSubview(webView)
        
        webView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        guard let url = URL(string: "https://www.baidu.com") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
