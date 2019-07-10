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
            
            for item in items {
                item.directory = directory
            }

            emotions += items
        }
    }
    @objc var bgImageName: String?
    
    @objc var emotions = [MQLEmotion]()
    
    var numberOfPages: Int {
        return (emotions.count - 1 ) / 20 + 1
    }
    
    //根据页数返回20个表情
    func emotion(page: Int) -> [MQLEmotion] {
        
        let count = 20
        
        let location = page * count
        var length = count
        
        if (location + length) > emotions.count {
            length = emotions.count - location
        }
        
        let array = emotions as NSArray
        let range = NSRange(location: location, length: length)
        return array.subarray(with: range) as! [MQLEmotion]
    }
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["emotions" : MQLEmotion.classForCoder()]
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}

