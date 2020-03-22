//
//  ZDCFUniversal.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#ifndef ZDClassFollower_ZDCFUniversal_h
#define ZDClassFollower_ZDCFUniversal_h

#define kZDCFNeedLoginKey @"kZDCFNeedLoginKey"
#define kZDCFLoginSuccessfullyKey @"kZDCFLoginSuccessfullyKey"

typedef void (^ZDCFBooleanWithErrorBlock)(BOOL succeeded, NSError *error);
typedef void (^ZDCFBooleanWithDtlBlock)(BOOL succeeded, NSString *dtl);

#endif
