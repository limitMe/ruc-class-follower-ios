//
//  ZDCFUserActions.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFUserActions.h"
#import "ZDCFLifeCycleModel.h"
#import "AFNetworking/AFNetworking.h"

@implementation ZDCFUserActions

+(BOOL)prepareToken{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *temp = [userDefaultes stringForKey:@"ZDCFToken"];
    if (temp == nil) {
        return NO;
    }
    [[ZDCFLifeCycleModel getSingleton] setAccess_token:temp];
    
    temp = [userDefaultes stringForKey:@"ZDCFSsid"];
    if (temp == nil) {
        return NO;
    }
    [[ZDCFLifeCycleModel getSingleton] setSsid:temp];
    return YES;
}

+(void)refreshTokenWithSSID:(NSString *)ssid password:(NSString *)passwd callback:(ZDCFBooleanWithErrorBlock)callback{
    
    NSString * const grant_type = @"password";
    NSString * const username = [NSString stringWithFormat:@"ruc:%@",ssid];
    NSString * const password = passwd;
    NSString * const client_id = @"马赛克";
    NSString * const client_secret = @"马赛克";
    NSString * const scope = @"all";
    
    NSDictionary *paras = @{
                            @"grant_type": grant_type,
                            @"username": username,
                            @"password": password,
                            @"client_id": client_id,
                            @"client_secret": client_secret,
                            @"scope": scope
                            };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://uc.tiup.cn/oauth/token" parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject[@"access_token"]) {
            [[ZDCFLifeCycleModel getSingleton] setAccess_token:responseObject[@"access_token"]];
             [[ZDCFLifeCycleModel getSingleton] setSsid:ssid];
            [self writeTokenToLocal];
            callback(YES,nil);
        }else{
            callback(NO,nil);}

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO,error);
        
    }];
}

+(void)verifyCurrentTokenWithCallback:(ZDCFBooleanWithDtlBlock)callback{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *verifyUrl = [NSString stringWithFormat:@"http://v.ruc.edu.cn/educenter/api/users/me?school_domain=v.ruc.edu.cn&access_token=%@",[[ZDCFLifeCycleModel getSingleton] access_token]];
    [manager GET:verifyUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            callback(YES,nil);
        }else if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:401]]){
            callback(NO,@"token失效，需要重新登录");
        }else {
            callback(NO,@"解析校验借口时出现未知错误");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(NO,[error localizedDescription]);
    }];

}

+(void)writeTokenToLocal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[ZDCFLifeCycleModel getSingleton] access_token] forKey:@"ZDCFToken"];
    [userDefaults setObject:[[ZDCFLifeCycleModel getSingleton] ssid] forKey:@"ZDCFSsid"];
    [userDefaults synchronize];
}

@end
