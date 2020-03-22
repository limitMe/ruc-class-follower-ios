//
//  ZDCFSingleStudentModel.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFSingleStudentModel.h"
#import "ZDCFCourseRecordModel.h"

@implementation ZDCFSingleStudentModel

+ (id)getSingleton{
    static ZDCFSingleStudentModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZDCFSingleStudentModel alloc] init];
        sharedInstance.classSet = [NSMutableSet new];
    });
    return sharedInstance;
}

@end
