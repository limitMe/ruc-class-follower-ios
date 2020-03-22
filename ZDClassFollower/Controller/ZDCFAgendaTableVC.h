//
//  ZDCFAgendaTableVC.h
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDCFCallbackDelegate  <NSObject>
@required
-(void)setNeedRefresh;

@end


@interface ZDCFAgendaTableVC : UITableViewController <ZDCFCallbackDelegate>

@property BOOL loadedMark;
-(void)setNeedRefresh;

@end

