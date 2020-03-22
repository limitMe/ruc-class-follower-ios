//
//  ZDCFCourseRecordModel.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCFCourseRecordModel : NSObject <NSCopying>

@property (strong, nonatomic) NSNumber *weekday;
@property (strong, nonatomic) NSNumber *bigclass;
@property BOOL isHalf;
@property (strong, nonatomic) NSString *classname;
@property (strong, nonatomic) NSString *studentname;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSNumber *ssid;
@property (strong, nonatomic) NSNumber *startWeek;
@property (strong, nonatomic) NSNumber *endWeek;

@end
