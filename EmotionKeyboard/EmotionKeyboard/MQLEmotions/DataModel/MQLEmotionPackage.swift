//
//  MQLEmotionPackage.swift
//  EmotionKeyboard
//  //挫折和惊喜
//  Created by maqianli on 2019/7/2.
//  Copyright © 2019 onesmart. All rights reserved.
//

import UIKit
import YYModel

@objcMembers class MQLEmotionPackage: NSObject {
    
    @objc var groupName: String?
    @objc var directory: String?{
        didSet{
            guard let directory = directory ,
                let path = Bundle.main.path(forResource: "MQLEmotions.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath),
                let items = NSArray.yy_modelArray(with: MQLEmotion.self, json: array) as? [MQLEmotion]
                else { return }

            emotions += items
            
        }
    }
    
    @objc var emotions = [MQLEmotion]()
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["emotions" : MQLEmotion.classForCoder()]
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}

