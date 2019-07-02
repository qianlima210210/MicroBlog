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
        guard let path = Bundle.main.path(forResource: "MQLEmotions.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let packages = NSArray.yy_modelArray(with: MQLEmotionPackage.self, json: array) as? [MQLEmotionPackage]
            else { return }
        
        self.packages += packages
    }
}

extension MQLEmotionsManager {
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
}
