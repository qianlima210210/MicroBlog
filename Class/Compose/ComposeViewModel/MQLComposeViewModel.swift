//
//  MQLComposeViewModel.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/7/7.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLComposeViewModel: NSObject {

    /// 发布文本微博
    ///
    /// - Parameter text: 要发布的文本
    func statusesUpdate(text: String, completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> () {
        let url = "https://api.weibo.com/2/statuses/update.json"
        let parameters = ["status": text]
        
        NetworkRequestEngine.share.accessTokenRequest(url, method: .post, parameters: parameters) { (value, error) in
            completionHandler(value, error)
        }
    }
}
