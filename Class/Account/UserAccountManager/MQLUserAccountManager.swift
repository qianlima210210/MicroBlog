//
//  MQLUserAccountManager.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/16.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

@objcMembers class MQLUserAccountManager: NSObject {
    
   @objc var access_token: String?
   @objc var uid: String?
   @objc var expires_in: TimeInterval = 0
    
    var userLogon: Bool{
        return access_token != nil
    }
    
    static let share: MQLUserAccountManager = MQLUserAccountManager()
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
