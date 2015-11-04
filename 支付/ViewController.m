//
//  ViewController.m
//  支付
//
//  Created by 刘曼 on 15/11/4.
//  Copyright (c) 2015年 刘曼. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "LoadAppViewController.h"
@interface ViewController ()<WXApiDelegate, UIAlertViewDelegate>

@end

@implementation ViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationErr:) name:@"payErr" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationSuc:) name:@"paySuccess" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}
//微信支付失败后
- (void)notificationErr:(NSNotification *)noti{
    //一般是进行界面的跳转
    NSDictionary *dic = noti.userInfo;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:dic[@"result"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
//微信支付成功后
- (void)notificationSuc:(NSNotification *)noti{
    //一般是进行界面的跳转
    NSDictionary *dic = noti.userInfo;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:dic[@"result"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark  微信支付
- (IBAction)WXPay:(UIButton *)sender {
    NSLog(@"微信支付");
    //一般先向自己的后台提供的接口去请求数据，得到返回的数据（一般包括一些商品信息，商品名称，价格，规格，订单号等），，在这里我们的这些东西都是写死的
    //这个字典应该是返回的数据 (notify_url是必须的返回的) 订单号写自己接口返回的
    NSDictionary *bodyDic = @{@"body":@"商品名称:统一鲜橙多",@"notify_url":@"http://pay.test.i500m.com/api/social-notify/wxpayapp",@"order_sn":[NSString stringWithFormat:@"2%d", rand()],@"total_fee":@"1"};//1分钱
    
    BOOL isFix = [WXApi isWXAppInstalled];
    //如果安装了微信则发起支付，，如果没有安装微信则提示安装
    if (isFix) {
        [self sendPay_demo:bodyDic];
    }else{
        //提示安装
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"去安装微信" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即下载", nil];
        [alert show];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *WXAppUrl = [WXApi getWXAppInstallUrl];
        NSLog(@"微信下载地址是 =%@", WXAppUrl);
        LoadAppViewController *load = [[LoadAppViewController alloc]init];
        load.WXAppUrlStr = WXAppUrl;
        [self presentViewController:load animated:YES completion:nil];
        
    }
}
- (void)sendPay_demo:(NSDictionary *)tmpDic
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:tmpDic];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
//        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
