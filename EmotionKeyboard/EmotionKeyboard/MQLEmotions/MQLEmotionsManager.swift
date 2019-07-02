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
