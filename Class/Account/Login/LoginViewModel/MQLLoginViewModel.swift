//
//  MQLLoginViewModel.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/14.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLLoginViewModel: NSObject {
    
    var dataModel = MQLLoginDataModel()

    //Oauth2/access token
    func access_token(code: String, completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> () {
        
        let parameters = ["client_id":appKey, "client_secret":appSecret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirect_uri]
        NetworkRequestEngine.share.request("https://api.weibo.com/oauth2/access_token", method: .post, parameters: parameters) { (value, error) in
            
            MQLUserAccountManager.share.access_token = value?["access_token"] as? String
            MQLUserAccountManager.share.uid = value?["uid"] as? String
            MQLUserAccountManager.share.expires_in = value?["expires_in"] as? TimeInterval ?? 0
            
            completionHandler(value, error)
        }
    }
}
