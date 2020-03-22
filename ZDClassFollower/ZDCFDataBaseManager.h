//
//  ZDCFDataBaseManager.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@class ZDCFCourseRecordModel;
#import "ZDCFUniversal.h"

@interface ZDCFDataBaseManager : NSObject

@property (strong, nonatomic) FMDatabaseQueue *queue;

+ (id)getSingleton;

- (void)insertACourseRecord:(ZDCFCourseRecordModel *)model;
- (void)refreshTimeSpotModelWithCallback:(ZDCFBooleanWithDtlBlock)callback;
- (void)refreshCurrentStudentModelWithSSID:(NSNumber *)ssid callback:(ZDCFBooleanWithDtlBlock)callback;
- (void)deleteStudentWithSSID:(NSNumber *)ssid callback:(ZDCFBooleanWithDtlBlock)callback;

@end
