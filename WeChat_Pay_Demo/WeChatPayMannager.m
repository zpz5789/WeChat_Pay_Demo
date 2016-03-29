//
//  WeChatPayMannager.m
//  WeChat_Pay_Demo
//
//  Created by zpz on 16/3/4.
//  Copyright © 2016年 zpz. All rights reserved.
//

#import "WeChatPayMannager.h"
#import "AFNetworking.h"
#import "JJProgressHUD.h"
#import "XMLDictionary.h"
#import "WXApi.h"
#import "DataMD5.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>

@interface WeChatPayMannager ()

@end
@implementation WeChatPayMannager

+ (void)wxPayWithOrderName:(NSString *)orderName
               orderDetail:(NSString *)orderDetail
                   orderNo:(NSString *)orderNo
               orderAmount:(NSString *)orderAmount
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //公众账号ID
    [dict setObject:kWxPayAppid forKey:@"appid"];
    //商户号
    [dict setObject:kWxPayMchid forKey:@"mch_id"];
    //商品名称(描述)
    [dict setObject:orderName forKey:@"body"];
    //随机字符串
    [dict setObject:[self getRandomString] forKey:@"nonce_str"];
    //订单号
    [dict setObject:orderNo forKey:@"out_trade_no"];
    //本机IP
    [dict setObject:[self deviceIPAdress] forKey:@"spbill_create_ip"];
    //支付金额
    NSString * amoutmomey =[NSString stringWithFormat:@"%0.f",[orderAmount floatValue] * 100];
    [dict setObject:amoutmomey forKey:@"total_fee"];
    //交易类型
    [dict setObject:@"APP" forKey:@"trade_type"];
    //回调Url
    [dict setObject:kNotifyUrl forKey:@"notify_url"];
    //签名
    NSString *sign = [self partnerSignOrder:dict payKey:kWxPartnerid];
    [dict setObject:sign forKey:@"sign"];
    
    NSString *postStr = [dict XMLString];
    [self startWeChatPayWithXmlStr:postStr];
}

+ (void)startWeChatPayWithXmlStr:(NSString *)xml
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];

    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        //返回微信服务器的签名验证信息，即预订单
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [dic objectForKey:@"mch_id"];//商户号
            request.prepayId= [dic objectForKey:@"prepay_id"];//预支付交易会话ID
            request.package = @"Sign=WXPay";//扩展字段
            request.nonceStr= [dic objectForKey:@"nonce_str"];//随机字符串
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            DataMD5 *md5 = [[DataMD5 alloc] init];
            
            //#warning mark - 传入appID
            //#warning mark - 第二次签名：发起正式支付阶段，第一个参数传入partnerID
            //签名
            request.sign = [md5 createMD5SingForPay:kWxPayAppid partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp payKey:kWxPartnerid];
            //调用微信
            [WXApi sendReq:request];
        }else{
            NSLog(@"参数不正确，请检查参数");
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//签名
+ (NSString *)partnerSignOrder:(NSDictionary*)paramDic payKey:(NSString *)payKey
{
    NSArray *keyArray = [paramDic allKeys];
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray)
    {
        if ([paramDic[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    [paramString appendFormat:@"&key=%@", payKey];
    
    NSString *signString = [[self signString:paramString] uppercaseString];

    return  signString;
}


+ (NSString *)signString:(NSString*)origString
{
    const char *original_str = [origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);//调用md5
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

//本机ID
+ (NSString *)deviceIPAdress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}


//生成随机字符串
+ (NSString *)getRandomString
{
    NSString *str = [NSString stringWithFormat:@"%s",genRandomString(32)];
    return str;
}

char* genRandomString(int length)
{
    int flag, i;
    char* string;
    srand((unsigned) time(NULL ));
    if ((string = (char*) malloc(length)) == NULL )
    {
        return NULL ;
    }
    
    for (i = 0; i < length - 1; i++)
    {
        flag = rand() % 3;
        switch (flag)
        {
            case 0:
                string[i] = 'A' + rand() % 26;
                break;
            case 1:
                string[i] = 'a' + rand() % 26;
                break;
            case 2:
                string[i] = '0' + rand() % 10;
                break;
            default:
                string[i] = 'x';
                break;
        }
    }
    string[length - 1] = '\0';
    return string;
}
@end
