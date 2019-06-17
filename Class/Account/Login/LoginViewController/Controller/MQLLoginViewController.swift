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
    
    var webView = WKWebView()
    
    @IBOutlet weak var webViewContainer: UIView!
    var viewModel = MQLLoginViewModel()
    
    var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }
    
    deinit {
        
    }

    func generalInit() -> () {
        title = "登录"
        setupBarButtonItem()
        startWebView()
    }
    
    @objc private func backBtnClicked(sender: UIBarButtonItem?) -> () {
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
        webView.scrollView.isScrollEnabled = false
        webViewContainer.addSubview(webView)
        
        webView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        guard let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirect_uri)") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}


extension MQLLoginViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        guard let url = navigationAction.request.url?.absoluteString as NSString? else{
            decisionHandler(.cancel)
            return
        }
        
        print("url=\(url)")
        //error=access_denied
        let contains = "error=access_denied"
        if url.contains(contains) {
            backBtnClicked(sender: nil)
            decisionHandler(.cancel)
            return
        }
        
        let prefix = "https://api.weibo.com/oauth2/default.html?code="
        if url.hasPrefix(prefix) {
            let code = url.substring(from: prefix.count)
            print("code=\(code)")
            access_token(code: code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        hud = MBProgressHUD.showAdded(to: webView, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        hud?.hide(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        hud?.hide(animated: true)
    }
}

extension MQLLoginViewController {
    func access_token(code: String) -> () {
        viewModel.access_token(code: code) { (value, error) in
            if error == nil {
                MBProgressHUD.showSuccessHUDAdded(to: self.webView, text: "授权成功")
            }else{
                MBProgressHUD.showFailtureHUDAdded(to: self.webView, text: "授权失败")
            }
        }
    }
}

