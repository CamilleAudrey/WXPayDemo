//
//  LoadAppViewController.m
//  支付
//
//  Created by 刘曼 on 15/11/4.
//  Copyright (c) 2015年 刘曼. All rights reserved.
//

#import "LoadAppViewController.h"

@interface LoadAppViewController ()

@end

@implementation LoadAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *dismissLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [dismissLabel setTitle:@"返回" forState:UIControlStateNormal];
    [dismissLabel addTarget:self action:@selector(cloked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissLabel];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, 320, 440)];
    web.backgroundColor = [UIColor redColor];
    [self.view addSubview:web];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.WXAppUrlStr]];
    [web loadRequest:request];
    
}
- (void)cloked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
