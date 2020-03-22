//
//  ZDCFLifeCycleModel.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFLifeCycleModel.h"

@implementation ZDCFLifeCycleModel

+ (id)getSingleton{
    static ZDCFLifeCycleModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZDCFLifeCycleModel alloc] init];
    });
    return sharedInstance;
}

@end
