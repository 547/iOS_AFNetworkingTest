//
//  ViewController.m
//  AFNetworkingTest
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"//af封装的一些关于UI方面的请求操作
@interface ViewController ()

@end

@implementation ViewController
{
    NSURLSessionDownloadTask *downloadTask;
    NSData *savedData;
    AFHTTPSessionManager *downloadManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    savedData=[[NSData alloc]init];
    downloadManager=[AFHTTPSessionManager manager];
    [self networkingGetRequest];
}
/*
 1.系统的NSURLConnection
 2.ASIHttprequest 年份比较老功能全。但不更新了
 3.AFNetWorking 功能全、更新频率高、单位使用率高
 4.NSURLSession
 */
-(void)networkingGetRequest
{
    /*
     发get请求
     1.创建一个AFURLSessionManager对象
     此时不会发送请求，因为该方法返回一个NSURLSessionDataTask
     af 对于服务器返回的数据的格式有一定的要求
     */
    AFHTTPSessionManager *httpManager=[AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    httpManager.responseSerializer=[AFHTTPResponseSerializer serializer];//设置对应的响应类型
   [httpManager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSString *dataStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       
        NSLog(@"成功====%@",dataStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error===%@",error);
    }];
//    [dataTask resume];//请求===不用再发请求，作者已经在方法体里面已经发过请求了
}

/*
 3.0 
 1.创建manager
 2.为manager添加请求或者响应请求（将来看服务器返回的数据）
 3.manager对象
 */

//发Post请求
-(void)postTest
{
    // 初始化Manager
    AFHTTPSessionManager *postManager=[AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    postManager.responseSerializer =[AFHTTPResponseSerializer serializer];
    // 请求的参数==post请求追加的参数，get请求不需要直接填nil
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"ST_R",@"command",@"123",@"name",@"123",@"psw", nil];
     // post请求
   [postManager POST:@"http://localhost:8080/st/s" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSLog(@"成功====%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"！！！！有错误+++++%@",error);
    }];
//    [dataTask resume];//请求===不用再发请求，作者已经在方法体里面已经发过请求了
}

//上传
- (IBAction)upData:(id)sender {
    
    
}

//开始下载
- (IBAction)downLoad:(id)sender {
    
    NSString *urlStr=@"https://192.168.1.136:8080/ceSSsever/Xcode51.dmg";
    
  downloadTask = [downloadManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%0.2f%%",downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *pathStr=   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"Xcode51.dmg"];
        NSURL *downloadPath=[NSURL fileURLWithPath:pathStr];
        return downloadPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //
        if (error) {
            NSLog(@"error+++++%@",error);
        }else
        {
            NSLog(@"成功！！！");
        }
    }];
    [downloadTask resume];
}
//暂停下载
- (IBAction)pauseDownload:(id)sender {
    
    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        savedData=resumeData;
//        NSLog(@"resumeData====%@",[[NSString alloc]initWithData:resumeData encoding:NSUTF8StringEncoding]);
        
    }];
    
}
//继续下载
- (IBAction)continueDownload:(id)sender {
    
  downloadTask= [downloadManager downloadTaskWithResumeData:savedData progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%0.2f%%",downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *pathStr=   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"Xcode51.dmg"];
        NSURL *downloadPath=[NSURL fileURLWithPath:pathStr];
        return downloadPath;

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error+++++%@",error);
        }else
        {
            NSLog(@"成功！！！");
        }

    }];
    [downloadTask resume];
}











-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self postTest];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
