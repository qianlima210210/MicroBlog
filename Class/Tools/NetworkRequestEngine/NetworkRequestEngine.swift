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
    func upload(url: URLConvertible, parameters: Parameters? = nil, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
        manager.upload(multipartFormData: { (multipartFormData) in
            
            /**multipartFormData.append(<#T##data: Data##Data#>, withName: <#T##String#>, fileName: <#T##String#>, mimeType: <#T##String#>)
             采用post表单上传,参数解释：*  withName:和后台服务器的name要一致;
                                       *  fileName:可以充分利用写成用户的id，但是格式要写对;
                                       *   mimeType：规定的，要上传其他格式可以自行百度查一下;
              如果需要上传多个文件,就多调用几次*/
            
            /**遍历参数字典
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    
                }
            }*/
            
        }, to: url) { (encodingResult) in
            switch encodingResult {
                case .success(let upload, _, _):
                    //上传进度
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                    })
                    
                    //上传成功
                    upload.responseJSON(completionHandler: { (response) in
                        //对于response的具体处理放在视图模型中
                        completionHandler(response)
                    })
                case .failure(let error):
                    print(error)
            }
        }
        
    }
}



