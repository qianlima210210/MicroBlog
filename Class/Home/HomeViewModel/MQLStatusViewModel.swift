//
//  MQLStatusViewModel.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/21.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

class MQLStatusViewModel: NSObject {
    
    var dataModel: Status
    
    var heightOfZhengWen: CGFloat = 200
    var heightOfBeiZhuanFaZhengWen: CGFloat = 50
    var sizeOfPicturesViewContainer = CGSize()
    var heightOfBottomToolBar: CGFloat = 28
    
    var touXiangImage: UIImage?
    var huiYuanImage: UIImage?
    var renZhengImage: UIImage?
    
    //如果是转发微博，返回被转发的配图
    //如果是自发微博，返回自发微博的配图
    var pic_urls: [[String:AnyObject]]? {
        if dataModel.retweeted_status != nil {
            return dataModel.retweeted_status?.pic_urls
        }else{
            return dataModel.pic_urls
        }
    }
    
    
    init(_ dataModel: Status) {
        self.dataModel = dataModel
        super.init()
        
        //mbrak会员等级
        let mbrank = dataModel.user?.mbrank ?? 0
        switch dataModel.user?.mbrank {
            case 1, 2, 3, 4, 5, 6:
            huiYuanImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        default:
            huiYuanImage = UIImage(named: "common_icon_membership_expired")
        }
        
        //verified_type //认证类型，-1无认证；0认证用户；2、3、5企业认证，220达人
        let verified_type = dataModel.user?.verified_type ?? -1
        switch verified_type {
        case 0:
          renZhengImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            renZhengImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            renZhengImage = UIImage(named: "avatar_grassroot")
        default:
            renZhengImage = nil
        }
        
        //获取配图大小
        sizeOfPicturesViewContainer = calcPictureSize(count: pic_urls?.count ?? 0)
        
    }
    
    func calcPictureSize(count: Int) -> CGSize {
        
        if count == 0 {
            return CGSize()
        }
        
        //行数
        let row: CGFloat = CGFloat((count - 1 ) / 3 + 1)
            
        //图片宽度
        let picWidth = widthOfPicturesViewContainer / 3
        
        //PicturesViewContainer高度
        let heightOfPicturesViewContainer = outerMargin + row * picWidth + CGFloat(row - 1) * innerMargin
        
        
        return CGSize(width: widthOfPicturesViewContainer, height: heightOfPicturesViewContainer)
    }
    
}
