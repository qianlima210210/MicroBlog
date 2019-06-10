//
//  NetworkRequestEngine.swift
//  MicroBlog
//
//  Created by maqianli on 2019/6/10.
//  Copyright © 2019 qianli. All rights reserved.
//

import Foundation
import Alamofire

/*
 * 配置各种网络请求环境
 */
enum  NetworkEnvironment{
    case Development
    case Test
    case Distribution
}

class NetworkRequestEngine: NSObject {
    
    //单例
    static let share:NetworkRequestEngine  = {
        let share = NetworkRequestEngine()
        share.currentNetworkEnvironment = .Development
        return share
    }()
    
    //定义多个私有属性，来存储不同的服务地址
    // 分享服务
    private var shareBaseUrl = ""
    // 一般服务
    private var generalBaseUrl = ""
    
    //设置当前网络请求环境
    private var currentNetworkEnvironment : NetworkEnvironment = .Test {
        //根据当前网络请求环境不同，服务地址发生改变
        didSet {
            if(currentNetworkEnvironment == .Development){
                
                shareBaseUrl = "http://dev-***.com/common-portal/"
                generalBaseUrl = "http://dev-***.com:8080/isp-kongming/"
                
            }else if(currentNetworkEnvironment == .Test){
                
                shareBaseUrl = "http://test-***.com/common-portal/"
                generalBaseUrl = "http://test-***.com/isp-kongming/"
                
            }else{
                
                shareBaseUrl = "https://***.com/common-portal/"
                generalBaseUrl = "https://***.com/isp-kongming/"
                
            }
        }
    }
    
    //提供配置SessionManager的机会
    private var manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        return Alamofire.SessionManager(configuration: configuration)
    }();
    
    
    /// composeRequestUrl有多少个BaseUrl成员就应该有多少个这样的函数
    ///
    /// - Parameter urlPath: 路径
    /// - Returns: 完整接口地址
    func composeRequestUrl(urlPath: String) -> String {
        return generalBaseUrl + urlPath
    }
    
    // Get、Post Request
    func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        completionHandler: @escaping (DataResponse<Any>) -> Void){
        
        manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            //对于response的具体处理放在视图模型中
            completionHandler(response)
        }
    }
    
    //上传文件
    
}



