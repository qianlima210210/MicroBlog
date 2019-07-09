//
//  MQLEmotionsManager.swift
//  EmotionKeyboard
//
//  Created by maqianli on 2019/7/2.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit

class MQLEmotionsManager: NSObject {
    
    static var emotionsManager = MQLEmotionsManager()
    @objc var packages = [MQLEmotionPackage]()
    
    var bundle: Bundle? = {
        guard let path = Bundle.main.path(forResource: "MQLEmotions.bundle", ofType: nil) else {
                return nil
        }
        
        return Bundle(path: path)
    }()
    
    private override init() {
        super.init()
        loadPackages()
    }

    override var description: String{
        return yy_modelDescription()
    }
}

extension MQLEmotionsManager {
    func loadPackages() -> () {
        guard let bundle = bundle,
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let packages = NSArray.yy_modelArray(with: MQLEmotionPackage.self, json: array) as? [MQLEmotionPackage]
            else { return }
        
        self.packages += packages
    }
}

extension MQLEmotionsManager {
    
    /// 获取表情对象
    ///
    /// - Parameter chs: 中文描述
    /// - Returns: 表情对象
    func getEmotionWith(chs: String?) -> MQLEmotion? {
        guard let chs = chs else { return nil }
        
        for package in packages {
            let emotions = package.emotions
            let result = emotions.filter { (emotion) -> Bool in
                return emotion.chs == chs
            }
            if result.count > 0{
                return result[0]
            }
        }
        
        return nil
    }
    
    /// 将给定的字符串转换成属性字符串
    ///
    /// - Parameter string: 完整字符串
    /// - Returns: 属性字符串
    func emotionString(string: String, font: UIFont) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: string)
        
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attributeString
        }
        
        let matches = regx.matches(in: attributeString.string, options: [], range: NSRange(location: 0, length: attributeString.string.count))
        
        for m in matches.reversed() {
            let r = m.range(at: 0)
            let subStr = (attributeString.string as NSString).substring(with: r)
            
            guard let em = MQLEmotionsManager.emotionsManager.getEmotionWith(chs: subStr) else{
                continue
            }
            
            let imageText = em.imageText(font: font)
            attributeString.replaceCharacters(in: r, with: imageText)
            
        }
        
        //MARK: 关键统一设置字体用addAttributes，不要用setAttributes
        attributeString.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.red], range: NSRange(location: 0, length: attributeString.string.count))
        
        return attributeString
    }
}
