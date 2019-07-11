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
    @objc var code: String?{
        didSet{
            guard let code = code else { return  }
            
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
            
        }
    }
    
    //emoji字符串
    var emoji: String?
    
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
        
        let attachment = MQLTextAttachment()
        attachment.chs = chs
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        
        let attStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attStrM.addAttributes([NSAttributedString.Key.font : font], range: NSRange(location: 0, length: attStrM.length))
        
        return attStrM
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
