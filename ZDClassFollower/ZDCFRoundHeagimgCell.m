//
//  ZDCFRoundHeagimgCell.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/24.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFRoundHeagimgCell.h"

@interface ZDCFRoundHeagimgCell()


@end

@implementation ZDCFRoundHeagimgCell

- (void)awakeFromNib {
    [_headPic.layer setCornerRadius:22.5];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
