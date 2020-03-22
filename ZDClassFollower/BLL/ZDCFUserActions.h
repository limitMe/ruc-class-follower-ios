//
//  ZDCFUserActions.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZDCFUniversal.h"

@interface ZDCFUserActions : NSObject

+(BOOL)prepareToken;
+(void)refreshTokenWithSSID:(NSString *)ssid password:(NSString *)passwd callback:(ZDCFBooleanWithErrorBlock)callback;
+(void)verifyCurrentTokenWithCallback:(ZDCFBooleanWithDtlBlock)callback;

@end
