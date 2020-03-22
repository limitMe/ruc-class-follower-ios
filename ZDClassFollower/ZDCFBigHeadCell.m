//
//  ZDCFBigHeadCell.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFBigHeadCell.h"

@interface ZDCFBigHeadCell()


@end

@implementation ZDCFBigHeadCell

- (void)awakeFromNib {
    [_bigheadPic.layer setCornerRadius:60.0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
