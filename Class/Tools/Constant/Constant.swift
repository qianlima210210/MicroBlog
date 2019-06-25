//
//  Constant.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/14.
//  Copyright © 2019 qianli. All rights reserved.
//

import Foundation

let notificationOfUserLogin = "notificationOfUserLogin"
let notificationOfLoginSuccess = "notificationOfLoginSuccess"

let appKey = "1069040971"   //也叫作client_id
let appSecret = "dced87f388fc65cf3eb6861e0614be24"
let redirect_uri = "https://api.weibo.com/oauth2/default.html"       //授权回调地址

//图片外部边距
let outerMargin: CGFloat = 10
//图片内部边距
let innerMargin: CGFloat = 3
//PicturesViewContainer宽度
let widthOfPicturesViewContainer = UIScreen.main.bounds.width - 2 * outerMargin - 2 * innerMargin


