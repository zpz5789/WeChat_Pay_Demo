//
//  JJProgressHUD.m
//  JiJIuQinShu
//
//  Created by zpz on 15/12/29.
//  Copyright © 2015年 zpz. All rights reserved.
//

#import "JJProgressHUD.h"
/// iPhone尺寸定义
#define IS_IPHONE_4 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )480 )== 0)

#define IS_IPHONE_5 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )568 )== 0)

#define IS_IPHONE_6 (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )667 )== 0)

#define IS_IPHONE_6P (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )736 )== 0)
@implementation JJProgressHUD

//+ (void)JJProgressHUDShowActiveAndTextInView:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = text;
//    [[MBProgressHUD class] performSelector:@selector(JJProgressHUDhideInView:) withObject:view afterDelay:delay];
//
//}

/********************      **********************/
+ (void)show
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString*)status
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString*)string
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD showSuccessWithStatus:string];
}

+ (void)showErrorWithStatus:(NSString *)string
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showImage:(UIImage*)image status:(NSString*)status
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD showImage:image status:status];
}

+ (void)showOnlyTitle:(NSString *)title
{
    [JJProgressHUD setProgressAppearance];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, [UIScreen mainScreen].bounds.size.height * 0.35)];
    [SVProgressHUD showImage:nil status:title];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)setProgressAppearance
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [SVProgressHUD setCornerRadius:2];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
}

@end
