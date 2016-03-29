//
//  AppDelegate.m
//  WeChat_Pay_Demo
//
//  Created by zpz on 16/3/4.
//  Copyright © 2016年 zpz. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeChatPayMannager.h"
#import "JJProgressHUD.h"
//#import "WXApiManager.h"
@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate
{
    WeChatPayMannager *orderSuccessVC ;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
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
                [JJProgressHUD showOnlyTitle:strMsg];
                //发送微信支付结果通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINZHIFUJIEGUO" object:nil];
                NSLog(@" ---- 111支付成功 ---- ");
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default://根据返回的类型做出相应的处理
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [JJProgressHUD showOnlyTitle:strMsg];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
