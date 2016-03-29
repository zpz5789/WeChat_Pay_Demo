//
//  ViewController.m
//  WeChat_Pay_Demo
//
//  Created by zpz on 16/3/4.
//  Copyright © 2016年 zpz. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WeChatPayMannager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *name = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [name setTitle:@"购买" forState:UIControlStateNormal];
    [name addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:name];

    UIButton *name1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 100, 100)];
    [name1 setTitle:@"购买" forState:UIControlStateNormal];
    [name1 addTarget:self action:@selector(buyClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:name1];

    // Do any additional setup after loading the view, typically from a nib.
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


- (void)buyClick1{
    [WeChatPayMannager wxPayWithOrderName:@"123" orderDetail:@"sbsb" orderNo:[self generateTradeNO] orderAmount:@"0.01"];
}
- (void)buyClick
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app buyClick];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
