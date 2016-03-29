//
//  WeChatPayConfig.h
//  WeChat_Pay_Demo
//
//  Created by zpz on 16/3/4.
//  Copyright © 2016年 zpz. All rights reserved.
//

#ifndef WeChatPayConfig_h
#define WeChatPayConfig_h
#import "WXApi.h"

/***===================== 微信账号帐户资料=======================***/
//微信分配的公众账号ID（企业号corpid即为此appId）
#define kWxPayAppid @"wxa376214984366e6b"
//微信支付分配的商户号
#define kWxPayMchid  @"1305217601"
//商户密钥
#define kWxPartnerid @"xunfangzhiqiantong123zhiqiantong"
//支付结果回调页面
#define kNotifyUrl   @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
#endif /* WeChatPayConfig_h */
