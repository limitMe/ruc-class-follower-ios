//
//  ZDCFCourseRecordModel.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFCourseRecordModel.h"

@implementation ZDCFCourseRecordModel

-(id)copyWithZone:(NSZone *)zone{
    ZDCFCourseRecordModel *copy = [[[self class] alloc] init];
    
    if (copy)
    {
        copy.weekday = [self.weekday copy];
        copy.bigclass = [self.bigclass copy];
        copy.classname = [self.classname copy];
        copy.startWeek = [self.startWeek copy];
        copy.endWeek = [self.endWeek copy];
        copy.studentname = [self.studentname copy];
        copy.ssid = [self.ssid copy];
        copy.place = [self.place copy];
    }
    
    return copy;
}

@end
