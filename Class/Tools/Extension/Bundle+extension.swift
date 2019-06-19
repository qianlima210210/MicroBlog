//
//  Bundle+extension.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/30.
//  Copyright © 2019 qianli. All rights reserved.
//

import Foundation

extension Bundle {
    //计算型属性（只读属性）
    var nameSpace: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    
    //当前版本
    var currentVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
