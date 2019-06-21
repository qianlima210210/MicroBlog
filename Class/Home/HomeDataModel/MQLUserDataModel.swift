//
//  MQLUserDataModel.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/21.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

//用户数据模型
@objcMembers class MQLUserDataModel: NSObject {
    
    @objc var id: Int64 = 0
    @objc var screen_name: String?
    @objc var profile_image_url: String?
    @objc var verified_type: Int = 0//认证类型，-1无认证；0认证用户；2、3、5企业认证，220达人
    @objc var mbrank: Int = 0 //会员等级0~6
    
    override var description: String{
        return yy_modelDescription()
    }
}
