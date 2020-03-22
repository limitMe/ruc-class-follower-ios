//
//  ZDCFTimeSpotModel.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCFTimeSpotModel : NSObject

@property (nonatomic, strong) NSArray *timeSpotArray;

-(void)renewTimeSpotArray;
+ (id)getSingleton;

@end
