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
    
    @objc private func backBtnClicked(sender: UIBarButtonItem) -> () {
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充 - WebView 的注入，直接通过 js 修改 `本地浏览器中` 缓存的页面内容
    /// 点击登录按钮，执行 submit() 将本地数据提交给服务器！
    @objc private func autoFill() {
        
        // 准备 js
        let js = "document.getElementById('userId').value = 'qianlima210210@163.com'; " +
        "document.getElementById('passwd').value = '';"
        
        // 让 webview 执行 js
        //webView.stringByEvaluatingJavaScript(from: js)
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func setupBarButtonItem() -> () {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(backBtnClicked(sender:)), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    func startWebView() -> () {
        
        webView.backgroundColor = .orange
        webView.navigationDelegate = self
        webViewContainer.addSubview(webView)
        
        webView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        guard let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(appKek)&redirect_uri=\(redirect_uri)") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


extension MQLLoginViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        
        decisionHandler(.allow)
        
    }
}
