//
//  MQLUserAccountManager.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/6/16.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit

@objcMembers class MQLUserAccountManager: NSObject, NSCoding {
    
    @objc var access_token: String?
    @objc var uid: String?
    @objc var expires_in: TimeInterval = 0 {
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var expiresDate: Date?
    
    var screen_name: String?    //用户昵称
    var avatar_large: String?   //用户头像地址（大图）
    
    var userLogon: Bool{
        return access_token != nil
    }
    
    static let share: MQLUserAccountManager = {
        
        if let manager = MQLUserAccountManager.readFromLocal(),
            let expiresDate = manager.expiresDate {
            
            if expiresDate.compare(Date()) != .orderedDescending {
                manager.reset()
            }
            
            return manager
        }else{
            return MQLUserAccountManager()
        }
        
    }()
    
    override var description: String{
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
    }
    
    func reset() -> () {
        access_token = nil
        uid = nil
        expires_in = 0
        expiresDate = nil
        screen_name = nil
        avatar_large = nil
        
        saveToLocal()
    }
    
    func saveToLocal() -> () {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "MQLUserAccountManager")
    }
    
    static func readFromLocal() -> MQLUserAccountManager? {
        guard let data = UserDefaults.standard.data(forKey: "MQLUserAccountManager"),
        let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? MQLUserAccountManager else{
            return nil
        }
        
        return obj
    }
    
    //MARK: NSCoding协议的实现
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.access_token, forKey: "access_token")
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.expiresDate, forKey: "expiresDate")
        aCoder.encode(self.screen_name, forKey: "screen_name")
        aCoder.encode(self.avatar_large, forKey: "avatar_large")
    }

}
