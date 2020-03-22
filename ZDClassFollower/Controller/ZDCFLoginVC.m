//
//  ZDCFLoginVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFLoginVC.h"

#import "ZDCFUserActions.h"
#import "ZDCFUniversal.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface ZDCFLoginVC()
@property (strong, nonatomic) IBOutlet UITextField *ssidField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation ZDCFLoginVC

-(void)viewDidLoad{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL temp = [userDefaultes boolForKey:@"ZDCFLoginLearned"];
    if (temp == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"欢迎使用" message:@"RUC追课需要您的学工号及密码确认您的人大学生身份。学工号和密码仅用于和人大服务器通讯。RUC追课将不会在APP本地及服务器上保存您的相关信息。请知悉！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
        [userDefaultes setBool:YES forKey:@"ZDCFLoginLearned"];
    }
}

- (IBAction)login:(id)sender {
    NSString *errorMsg;
    [_ssidField resignFirstResponder];
    [_pwdField resignFirstResponder];
    if ([_ssidField.text isEqualToString:@""]) {
        errorMsg = @"人大学工号不能为空";
    }else if ([_pwdField.text isEqualToString:@""]) {
        errorMsg = @"密码不能为空";
    }
    
    
    if (errorMsg != nil) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"输入错误" message:errorMsg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
    }else {
        [SVProgressHUD showWithStatus:@"正在登录"];
        [ZDCFUserActions refreshTokenWithSSID:_ssidField.text password:_pwdField.text callback:^(BOOL suc, NSError *error){
            if(suc) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kZDCFLoginSuccessfullyKey
                                                                    object:nil];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD dismiss];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"登录失败" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [av show];
            }
        }];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![_ssidField isExclusiveTouch]) {
        [_ssidField resignFirstResponder];
    }
    if (![_pwdField isExclusiveTouch]) {
        [_pwdField resignFirstResponder];
    }
}

@end
