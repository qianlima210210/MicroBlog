//
//  MQLWebViewController.swift
//  MicroBlog
//
//  Created by maqianli on 2019/7/4.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import WebKit

class MQLWebViewController: MQLBaseViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://www.baidu.com") else{
            return
        }
        
        let request = URLRequest(url:url)
        
        webView = WKWebView()
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        
        if let webView = webView {
            contentView.addSubview(webView)
            webView.snp_makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
            }
            
            webView.load(request)
        }
    }

    override func setTableView() {
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "back", target: self, action: #selector(backClicked))
    }
    
    @objc func backClicked() -> () {
        guard let webView = webView else { return  }
        
        if webView.canGoBack {
            webView.goBack()
            
        }else{
            let alert = UIAlertController(title: "title", message: "你到根页面了", preferredStyle: .alert)
            let action0 = UIAlertAction(title: "ok", style: .destructive) { (action) in
                
            }
            alert.addAction(action0)
            present(alert, animated: true) {
                
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        
        print(navigationAction.request.url?.absoluteString)
        
        if navigationAction.targetFrame?.isMainFrame == false {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        if navigationAction.targetFrame?.isMainFrame == false {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
}
