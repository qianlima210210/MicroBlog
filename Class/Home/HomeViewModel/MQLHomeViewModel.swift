//
//  MQLHomeViewModel.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLHomeViewModel: NSObject {
    
    var dataModel: MQLHomeDataModel = MQLHomeDataModel()
    
    func getStatuses(isPullUp: Bool, completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> (){
       
        let since_id = isPullUp ? 0 : dataModel.statuses.first?.id ?? 0
        let max_id = isPullUp ? dataModel.statuses.last?.id ?? 0 : 0
        
        let parameters = ["since_id":"\(since_id)", "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        NetworkRequestEngine.share.accessTokenRequest("https://api.weibo.com/2/statuses/home_timeline.json", parameters:parameters) { (value, error) in
            
            if error == nil {//解析数据
                
                let array = NSArray.yy_modelArray(with: Status.self, json: value?["statuses"] as Any) as? [Status] ?? []
                self.dataModel.statuses = array + self.dataModel.statuses
            }
            completionHandler(value, error)
            
        }
    }
}
