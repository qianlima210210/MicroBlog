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
            //access_token请求失败
            if error != nil {
                completionHandler(value, error)
                return
            }
            //access_token请求成功
            MQLUserAccountManager.share.yy_modelSet(with: value ?? [:] )
            
            self.users_show(completionHandler: { (value, error) in
                
                MQLUserAccountManager.share.yy_modelSet(with: value ?? [:] )
                MQLUserAccountManager.share.saveToLocal()
                
                //users_show请求成功与否交与上层
                completionHandler(value, error)
            })
        }
    }
    
    //users/show
    func users_show(completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> () {
        
        guard let uid = MQLUserAccountManager.share.uid else {
            completionHandler(nil, NSError(domain: "uid为空", code: -1, userInfo: nil))
            return
        }
        
        let parameters = ["uid":uid]
        NetworkRequestEngine.share.accessTokenRequest("https://api.weibo.com/2/users/show.json", parameters:parameters) { (value, error) in
            
            completionHandler(value, error)
        }
    }
}



