//
//  XCNetworking.m
//  Pedometer
//
//  Created by 黄盛全 on 2020/12/24.
//  Copyright © 2020 黄盛全. All rights reserved.
//

#import "XCNetworking.h"

#define errMesg                         @"网络连接失败"

@interface XCNetworking ()

@property (nonatomic, retain) AFHTTPSessionManager *appManager;

@end

@implementation XCNetworking

+ (XCNetworking *)sharedInstance{
    static XCNetworking *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[XCNetworking alloc]init];
    });
    return handler;
}


- (void)getUrl:(NSString *)urlPath
    parameters:(NSMutableDictionary *)parametersDic
  headersParam:(NSMutableDictionary *)headersParamDic
     Complated:(XCNetworkingBlock)complation
{
        
    if (parametersDic.count > 0) {
        
        [self.appManager GET:urlPath
                  parameters:parametersDic
                     headers:headersParamDic
                    progress:^(NSProgress * _Nonnull downloadProgress) {

        }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"\n requestUrl = %@ \n parametersDic = %@\n requestData = %@",urlPath,parametersDic,responseObject);
            complation(responseObject,nil);
        }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n requestUrl = %@\n parametersDic = %@\n requestError = %@",urlPath,parametersDic,error);
            complation(nil,errMesg);
        }
         ];

    }
    
    
}





- (void)postUrl:(NSString *)urlPath
     parameters:(NSMutableDictionary *)parametersDic
   headersParam:(NSMutableDictionary *)headersParamDic
      Complated:(XCNetworkingBlock)complation
{
    if (parametersDic.count > 0) {
        
        [self.appManager POST:urlPath
                   parameters:parametersDic
                      headers:headersParamDic
                     progress:^(NSProgress * _Nonnull uploadProgress) {

            }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSLog(@"\n requestUrl = %@ \n parametersDic = %@\n requestData = %@",urlPath,parametersDic,responseObject);
            
                        NSDictionary *dic = responseObject;
                          if (dic[@"code"]) {
                              NSInteger code = [dic[@"code"] integerValue];
                              if (code > 101 && code <= 109) {
                                 
                              }
                          }
                      complation(responseObject,nil);
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"\n requestUrl = %@\n parametersDic = %@\n requestError = %@",urlPath,parametersDic,error);
                    complation(nil,errMesg);
                    
                  }
         ];
    }

}




- (AFHTTPSessionManager *)appManager {
    _appManager = nil;
    
    _appManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];//设置  服务器地址
    
    _appManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _appManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"text/jhtml", nil];
    _appManager.requestSerializer.timeoutInterval = 20;

    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [_appManager setResponseSerializer:serializer];
    
    return _appManager;
}


/**
 *  创建HTTPS证书
 *
 *  @return 证书
 */
- (AFSecurityPolicy *)customSecurityPolicy {
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"toushihttps" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    return securityPolicy;
}



@end
