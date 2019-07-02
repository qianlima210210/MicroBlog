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
    
    //所在目录
     @objc var directory: String?
    
    //对应image
    var image: UIImage?{
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "MQLEmotions.bundle", ofType: nil),
            let bundle = Bundle(path: path) else {
            return nil
        }
        
        //从非mainBundle中获取资源
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        return NSAttributedString(attachment: attachment)
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
