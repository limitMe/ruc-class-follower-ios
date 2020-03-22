//
//  ZDCFLifeCycleModel.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCFLifeCycleModel : NSObject

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *ssid;

+(id)getSingleton;

@end
