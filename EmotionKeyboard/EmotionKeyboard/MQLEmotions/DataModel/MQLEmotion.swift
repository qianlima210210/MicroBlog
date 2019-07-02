//
//  MQLEmotion.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/2.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit
import YYModel

@objcMembers class MQLEmotion: NSObject {

    @objc var chs: String?
    @objc var png: String?
    //true为emoji；false为default、其他
    @objc var type: Bool = false
    
    //emoji十六进制字符串
    @objc var code: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
