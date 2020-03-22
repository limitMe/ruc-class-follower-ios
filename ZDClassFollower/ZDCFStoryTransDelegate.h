//
//  ZDCFStoryTransDelegate.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#ifndef ZDClassFollower_ZDCFStoryTransDelegate_h
#define ZDClassFollower_ZDCFStoryTransDelegate_h

typedef enum : NSInteger{
    ZDCFStoryPush,
    ZDCFStoryMain,
} ZDCFStoryNames;

/**
 *  这个Protocol原来是为了使用delegate方式从Login页面跳转到Main页面
 *  后来还是采用了NSNotification的方式来做
 */
@protocol ZDCFStoryTransDelegate <NSObject>

@required
-(void)switchVCfrom:(ZDCFStoryNames)fromVC to:(ZDCFStoryNames)toVC;

@end


#endif
