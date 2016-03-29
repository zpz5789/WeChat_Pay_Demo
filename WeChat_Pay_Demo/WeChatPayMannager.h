//
//  WeChatPayMannager.h
//  WeChat_Pay_Demo
//
//  Created by zpz on 16/3/4.
//  Copyright © 2016年 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChatPayConfig.h"

/**
 使用说明：
 1.直接吧PLWeChatPay文件夹拖到你的工程里面
 2.配置一下系统库libsqlite3.0.dylib、libz.dzlib、CoreTelephony.framework、SystemConfiguration.frame添加到自己的项目中去，编译一下一般没有问题
 3.工程targets->Info->URL Types->配置微信分配的公众账号ID 如@"wxa376214984366abb" 用于跳转
 4.iOS9需要在info.plist中添加一项App Transport Security Settings —>Allow Arbitrary Loads设为YES
 5.在appDelegate中  遵守协议：
 @interface AppDelegate ()<WXApiDelegate>@end
 注册
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 //微信支付
 [WXApi registerApp:@"wxa376214984366e6b" withDescription:@"zhiqiantong"]; 
 return YES;
 }
 
 //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
 {
 if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",kWxPayAppid]].location != NSNotFound) {
 return  [WXApi handleOpenURL:url delegate:self];
 //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
 } else {
 return NO;
 }
 }
 
 //支付回调处理
  - (void)onResp:(BaseResp*)resp
 {
 //    如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
 NSString *strTitle;
 if([resp isKindOfClass:[PayResp class]]){
 
 //支付返回结果，实际支付结果需要去微信服务器端查询
 strTitle = [NSString stringWithFormat:@"支付结果"];
 
 switch (resp.errCode) {
 case WXSuccess:
 strMsg = @"支付结果：成功！";
 //发送微信支付结果通知
 [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINZHIFUJIEGUO" object:nil];
 NSLog(@" ---- 111支付成功 ---- ");
 NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
 break;
 
 default://根据返回的类型做出相应的处理
 strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
 NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
 break;
 }
 }
 }
 
 6.在需要调用支付的地方调用类似如下
 [WeChatPayMannager wxPayWithOrderName:@"商品名称" orderDetail:@"商品描述" orderNo:@"商品订单号" orderAmount:@"0.01"];
 **/

@interface WeChatPayMannager : NSObject

/**
 *  传入指定参数调用微信支付
 *
 *  @param orderName   订单名
 *  @param orderDetail 订单详情
 *  @param orderNo     订单号
 *  @param orderAmount 订单金额 单位元
 */

+ (void)wxPayWithOrderName:(NSString *)orderName
               orderDetail:(NSString *)orderDetail
                   orderNo:(NSString *)orderNo
               orderAmount:(NSString *)orderAmount;
@end
