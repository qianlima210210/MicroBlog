//
//  MQLHomeViewModel.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLHomeViewModel: NSObject {
    
    var dataModel: MQLHomeDataModel?
    
    func getStatuses(completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> (){
        NetworkRequestEngine.share.accessTokenRequest("https://api.weibo.com/2/statuses/home_timeline.json") { (value, error) in
            
            if error == nil {//解析数据
                self.dataModel = MQLHomeDataModel.yy_model(withJSON: value as Any)
            }
            completionHandler(value, error)
            
        }
    }
}
