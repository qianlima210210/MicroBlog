//
//  MQLTestViewController.swift
//  MicroBlog
//
//  Created by ma qianli on 2019/5/31.
//  Copyright © 2019 qianli. All rights reserved.
//

import UIKit
import Alamofire

class MQLTestViewController: MQLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generalInit()
    }
    
    @objc func titleBtnClicked(sender: UIBarButtonItem) -> () {
        print(#function)
        let vc = MQLTestViewController()
        
        let count = navigationController?.children.count ?? 0
        vc.title = "\(count)"

        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func generalInit() -> () {
        
        request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
}

extension MQLTestViewController {
    
    override func setTableView() {
        super.setTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "next", target: self, action: #selector(titleBtnClicked(sender:)))
    }
}

/*
 * 配置你的网络环境
 */
enum  NetworkEnvironment{
    case Development
    case Test
    case Distribution
}

//定义多个私有属性，来存储不同的服务地址
// 登录服务
private var LogInBase_Url = ""
// 普通服务
private var ProgressBase_Url = ""

//根据设置的运行环境不同，服务地址发生改变
private let CurrentNetWork : NetworkEnvironment = .Test

private func judgeNetwork(network : NetworkEnvironment = CurrentNetWork){
    
    if(network == .Development){
        
        LogInBase_Url = "http://dev-***.com/common-portal/"
        ProgressBase_Url = "http://dev-***.com:8080/isp-kongming/"
        
        
    }else if(network == .Test){
        
        LogInBase_Url = "http://test-***.com/common-portal/"
        ProgressBase_Url = "http://test-***.com/isp-kongming/"
        
    }else{
        
        LogInBase_Url = "https://***.com/common-portal/"
        ProgressBase_Url = "https://***.com/isp-kongming/"
        
    }
}

@objc protocol NetworkToolDelegate {
    // 登录请求
    @objc static optional func goToLogin(userName:String,
                          password:String,
                          completionHandler: @escaping(_ dict:[String : AnyObject]) -> (),
                          errorHandler: @escaping(_ errorMsg : String) ->(),
                          networkFailHandler: @escaping(_ error : Error) -> ())
    
    //GET 请求
   @objc static  optional func makeGetRequest(baseUrl : String,
                               parameters : [String:AnyObject],
                               successHandler: @escaping(_ json:Any) ->(),
                               errorMsgHandler : @escaping(_ errorMsg : String) ->(),
                               networkFailHandler:@escaping(_ error : Error) -> ())
    
    
    //POST 请求
    @objc static optional func makePostRequest(baseUrl : String,
                                parameters : [String:Any],
                                successHandler: @escaping(_ json:Any) ->(),
                                errorMsgHandler : @escaping(_ errorMsg : String) ->(),
                                networkFailHandler:@escaping(_ error : Error) -> ())
    
    /*  图片上传 请求
     * imageData : 图片二进制数组
     */
    @objc static optional func upDataIamgeRequest(baseUrl : String,
                                   parameters : [String : String],
                                   imageArr : [UIImage],
                                   successHandler: @escaping(_ dict:Any) ->(),
                                   errorMsgHandler : @escaping(_ errorMsg : String) -> (),
                                   networkFailHandler: @escaping(_ error:Error) -> ())
    
}

class NetWorkTool: NetworkToolDelegate {
    // 登录请求
    static func goToLogin(userName:String,
                          password:String,
                          completionHandler: @escaping(_ dict:[String : AnyObject]) -> (),
                          errorHandler: @escaping(_ errorMsg : String) ->(),
                          networkFailHandler: @escaping(_ error : Error) -> ()){
        
        print(#function)
        
    }
}


