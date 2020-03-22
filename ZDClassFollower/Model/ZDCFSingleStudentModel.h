//
//  ZDCFSingleStudentModel.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCFSingleStudentModel : NSObject

@property (strong, nonatomic) NSMutableSet *classSet;

+ (id)getSingleton;

@end
