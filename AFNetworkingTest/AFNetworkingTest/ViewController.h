//
//  ViewController.h
//  AFNetworkingTest
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 Seven. All rights reserved.
//


/*
 1.系统的NSURLConnection
 2.ASIHttprequest 年份比较老功能全。但不更新了
 3.AFNetWorking 功能全、更新频率高、单位使用率高
 4.NSURLSession
 
 AFNetWorking的使用：
 发送get、Post请求的三步
 1.创建manager
 2.为manager添加请求或者响应请求（将来看服务器返回的数据）
 3.manager对象去调用对应的请求方法（注意用对应的session类型接受之后才能请求成功）
 
 get请求示例：
 -(void)networkingGetRequest
 {

 发get请求
 1.创建一个AFURLSessionManager对象
 此时不会发送请求，因为该方法返回一个NSURLSessionDataTask
 af 对于服务器返回的数据的格式有一定的要求
 

 1.get请求url
 2.追加的请求数据
 3.当前进度
 4.成功返回
 5.失败返回
 
 此时不会去发请求 因为该方法返回给开发者一个NSURLSessionDatatask对象
 
 //af 对于服务器返回数据的格式有一定的要求
 
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合

1.AFHTTPSessionManager *httpManager=[AFHTTPSessionManager manager];
// 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
2.httpManager.responseSerializer=[AFHTTPResponseSerializer serializer];//设置对应的响应类型
3.[httpManager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSString *dataStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"成功====%@",dataStr);
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"error===%@",error);
}];
//    [dataTask resume];//请求===不用再发请求，作者已经在方法体里面已经发过请求了
}

 */
/*
检测当前设备的网络状态
 #pragma mark==测试网络情况
 -(void)testNetwork
 {
 AFNetworkReachabilityManager *networkManager=[AFNetworkReachabilityManager sharedManager];
 [networkManager startMonitoring];//开始监控
 [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
 switch (status) {
 case AFNetworkReachabilityStatusUnknown:
 NSLog(@"未知");
 break;
 case AFNetworkReachabilityStatusNotReachable:
 NSLog(@"没有网");
 break;
 case AFNetworkReachabilityStatusReachableViaWWAN:
 NSLog(@"付费网络");
 break;
 case AFNetworkReachabilityStatusReachableViaWiFi:
 NSLog(@"wifi");
 break;
 
 default:
 break;
 }
 }];
 }

 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)upData:(id)sender;
- (IBAction)downLoad:(id)sender;
- (IBAction)pauseDownload:(id)sender;
- (IBAction)continueDownload:(id)sender;

@end

