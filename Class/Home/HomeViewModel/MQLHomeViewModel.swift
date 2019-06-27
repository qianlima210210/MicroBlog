//
//  MQLHomeViewModel.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import SDWebImage

class MQLHomeViewModel: NSObject {
    
    var statusListViewModel = [MQLStatusViewModel]()
    
    func getStatuses(isPullUp: Bool, completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void) -> (){
       
        let since_id = isPullUp ? 0 : statusListViewModel.first?.dataModel.id ?? 0
        let max_id = isPullUp ? statusListViewModel.last?.dataModel.id ?? 0 : 0

        let parameters = ["since_id":"\(since_id)", "max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        NetworkRequestEngine.share.accessTokenRequest("https://api.weibo.com/2/statuses/home_timeline.json", parameters:parameters) { (value, error) in
            
            if error == nil {//解析数据
                
                let array = NSArray.yy_modelArray(with: Status.self, json: value?["statuses"] as Any) as? [Status] ?? []
                
                var arrayM = [MQLStatusViewModel]()
                for status in array {
                    let statusViewModel = MQLStatusViewModel(status)
                    arrayM.append(statusViewModel)
                }
                if isPullUp == true {
                    self.statusListViewModel = self.statusListViewModel + arrayM
                }else{
                    self.statusListViewModel = arrayM + self.statusListViewModel
                }
                
                //completionHandler(value, error), NSError?
                self.singlePic(arrayM: arrayM, completionHandler: completionHandler, value: value, error: error)
                
            }else{
                completionHandler(value, error)
            }
            
            
        }
    }
    
    //获取单张图大小
    func singlePic(arrayM: [MQLStatusViewModel], completionHandler: @escaping ([String:AnyObject]?, NSError?) -> Void, value: [String:AnyObject]?, error: NSError?) -> () {
        let group = DispatchGroup()
        
        for item in arrayM {
            
            guard let count = item.pic_urls?.count else{
                continue
            }
            
            if count == 1 {
                let thumbnail_pic = item.pic_urls?[0]["thumbnail_pic"] as? String ?? ""
                let url = URL(string: thumbnail_pic)
                
                group.enter()
                SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                    item.updatePictureSize(image: image)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completionHandler(value, error)
        }
    }
    
}
