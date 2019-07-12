//
//  ViewController.m
//  WKAliPay
//
//  Created by maqianli on 2019/7/12.
//  Copyright © 2019 onesmart. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    
}

//MARK: WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //NSString *urlStr = navigationAction.request.URL.absoluteString;
    
    //        alipay://alipayclient/?{"dataString":"h5_route_token=\"5ca0bf28bad7cdb27e9069853cfb67d7\"&is_h5_route=\"true\"","requestType":"SafePay","fromAppUrlScheme":"alipays"}
    
    NSDictionary *dict = @{@"dataString":@"h5_route_token=\"5ca0bf28bad7cdb27e9069853cfb67d7\"&is_h5_route=\"true\"",
                           @"requestType":@"SafePay",
                           @"fromAppUrlScheme":@"alipays"
                           };
    
    
    
    
    
    
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *urlStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    urlStr = [@"alipay://alipayclient/?" stringByAppendingString:urlStr];
    
    if ([urlStr hasPrefix:@"alipays://"] || [urlStr hasPrefix:@"alipay://"]) {
        NSURL* alipayURL = [self changeURLSchemeStr:urlStr];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:alipayURL];
        }
    }
    decisionHandler(WKNavigationActionPolicyCancel);
}

-(NSURL*)changeURLSchemeStr:(NSString*)urlStr{
    NSString* tmpUrlStr = urlStr.copy;
    if([urlStr containsString:@"fromAppUrlScheme"]) {
        tmpUrlStr = [tmpUrlStr stringByRemovingPercentEncoding];
        NSDictionary* tmpDic = [self dictionaryWithUrlString:tmpUrlStr];
        NSString* tmpValue = [tmpDic valueForKey:@"fromAppUrlScheme"];
        tmpUrlStr = [[tmpUrlStr stringByReplacingOccurrencesOfString:tmpValue withString:@"wkPay"] mutableCopy];
        tmpUrlStr = [[tmpUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] mutableCopy];
    }
    NSURL * newURl = [NSURL URLWithString:tmpUrlStr];
    return newURl;
}
-(NSDictionary*)dictionaryWithUrlString:(NSString*)urlStr{
    if(urlStr && urlStr.length&& [urlStr rangeOfString:@"?"].length==1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if(array && array.count==2) {
            NSString*paramsStr = array[1];
            if(paramsStr.length) {
                NSString* paramterStr = [paramsStr stringByRemovingPercentEncoding];
                NSData *jsonData = [paramterStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                return responseDic;
            }
        }
    }
    return nil;
}


@end
