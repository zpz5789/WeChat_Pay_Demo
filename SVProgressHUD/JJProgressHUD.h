//
//  JJProgressHUD.h
//  JiJIuQinShu
//
//  Created by zpz on 15/12/29.
//  Copyright © 2015年 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
@interface JJProgressHUD : NSObject
//只显示文字
+ (void)JJProgressHUDShowTextOnlyInView:(UIView *)view text:(NSString *)text hideDuration:(NSTimeInterval)duration;

//显示文字加转圈圈
+ (void)JJProgressHUDShowActiveAndTextInView:(UIView *)view text:(NSString *)text;
//+ (void)JJProgressHUDShowActiveAndTextInView:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay;
//默认显示
+ (void)JJProgressHUDshowInView:(UIView *)view;

//隐藏

+ (void)JJProgressHUDhideInView:(UIView *)view;

+ (void)JJProgressHUDAllhideInView:(UIView *)view;

//+ (void)JJProgressHUDhideInVie:(UIView *)view afterDelay:(NSTimeInterval)delay;

/******************** SVP *********************/

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage*)image status:(NSString*)status;
+ (void)showOnlyTitle:(NSString *)title;
+ (void)dismiss;

@end
