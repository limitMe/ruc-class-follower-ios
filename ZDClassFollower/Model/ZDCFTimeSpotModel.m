//
//  ZDCFTimeSpotModel.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFTimeSpotModel.h"

@implementation ZDCFTimeSpotModel

+ (id)getSingleton{
    static ZDCFTimeSpotModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZDCFTimeSpotModel alloc] init];
        [sharedInstance renewTimeSpotArray];
    });
    return sharedInstance;
}

-(void)renewTimeSpotArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i < 7; i++) {
        NSMutableArray *weekdayArray = [NSMutableArray new];
        for (int j = 0 ; j < 7; j++) {
            NSMutableSet *spot = [NSMutableSet new];
            [weekdayArray addObject:spot];
        }
        [tempArray addObject:[weekdayArray copy]];
    }
    _timeSpotArray = [tempArray copy];
}

@end
