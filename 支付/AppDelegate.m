//
//  AppDelegate.m
//  支付
//
//  Created by 刘曼 on 15/11/4.
//  Copyright (c) 2015年 刘曼. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"i500"];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}
//微信支付回调结果
- (void)onResp:(BaseResp *)resp{
    NSString *titleStr;
    if ([resp isKindOfClass:[PayResp class]]) {
        titleStr = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:{//成功支付
                // NSNotification *notification = [NSNotification notificationWithName:@"paySuccess" object:nil];
                //[[NSNotificationCenter defaultCenter] post]
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil userInfo:@{@"result":@"paySuccess"}];
            }
                break;
            case WXErrCodeCommon:{//签名错误，未注册APPID，项目设置APPID不正确，注册的APPID与设置的不匹配，其他异常等等
                //                NSNotification *notification = [NSNotification notificationWithName:@"payErr" object:nil];
                //                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payErr" object:nil userInfo:@{@"result":@"配置信息错误"}];
                
            }
                break;
            case WXErrCodeUserCancel:{//用户点击取消并返回
                //                NSNotification *notification = [NSNotification notificationWithName:@"payErr" object:nil];
                //                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payErr" object:nil userInfo:@{@"result":@"用户点击取消并返回"}];
                
            }
                break;
            case WXErrCodeSentFail:{//发送失败
                //                NSNotification *notification = [NSNotification notificationWithName:@"payErr" object:nil];
                //                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payErr" object:nil userInfo:@{@"result":@"发送失败"}];
                
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                // NSLog(@"微信不支持");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payErr" object:nil userInfo:@{@"result":@"微信不支持"}];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                // NSLog(@"授权失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payErr" object:nil userInfo:@{@"result":@"授权失败"}];
            }
                break;
                
                
            default:
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
