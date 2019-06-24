//
//  MQLHomeDataModel.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/29.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import YYModel

@objcMembers class Status: NSObject {
    @objc var id: Int64 = 0;
    @objc var text: String?
    @objc var user: MQLUserDataModel?
    
    @objc var reposts_count: Int64 = 0      //转发数
    @objc var comments_count: Int64 = 0     //评论数
    @objc var attitudes_count: Int64 = 0    //表态数
    
    override var description: String{
        return yy_modelDescription()
    }
}

@objcMembers class MQLHomeDataModel: NSObject {
    @objc var statuses = [Status]()
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["statuses" : Status.classForCoder()]
    }
}
