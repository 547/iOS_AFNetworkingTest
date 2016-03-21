# iOS_AFNetworkingTest

 1.系统的NSURLConnection
 2.ASIHttprequest 年份比较老功能全。但不更新了
 3.AFNetWorking 功能全、更新频率高、单位使用率高
 4.NSURLSession
 
 AFNetWorking的使用：
 发送get、Post请求的三步
 1.创建AFHTTPSessionManager对象
 2.为manager添加请求或者响应请求（将来看服务器返回的数据）
 3.manager对象去调用对应的请求方法（注意用对应的session类型接受之后才能请求成功）
 
 get请求示例：
 

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
 
 
-(void)networkingGetRequest
 {
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


post请求：
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

断点下载
//开始下载
- (IBAction)downLoad:(id)sender {
    
    /*
     1.destination 里面一定要返回url (一般都是路径生成url)
     2.暂停的时候一定要记着把已经下载好的数据接收出来(服务器返回的数据是临时的不接收就清空了)
     3.调用downloadTaskWithResumeData继续下载
     */

    NSString *urlStr=@"https://192.168.1.136:8080/ceSSsever/Xcode51.dmg";
   //AF断点下载的核心是如何保证一个DownloadTask在操作
  downloadTask = [downloadManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] progress:^(NSProgress * _Nonnull downloadProgress) {
       //此次操作的进度
        NSLog(@"下载进度：%0.2f%%",downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //如果destination不提供文件存储url，则默认为此次下载的东西不知道返回到哪，就会失败。所以一定要返回一个存储路径
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
    //如何保存此时已经下载的数据至关重要
    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        savedData=resumeData;//断点下载的核心
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

