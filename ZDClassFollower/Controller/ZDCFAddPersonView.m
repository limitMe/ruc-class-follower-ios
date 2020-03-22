//
//  ZDCFAddPersonView.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFAddPersonView.h"
#import "AFNetworking/AFNetworking.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ZDCFStudentInfoObj.h"
#import "ZDCFUserActions.h"
#import "ZDCFLifeCycleModel.h"
#import "ZDCFCourseRecordModel.h"
#import "ZDCFDataBaseManager.h"

@interface ZDCFAddPersonView ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIView *whiteBg;
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) NSMutableArray *StudentArray;
@property BOOL tokenVerified;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *whiteBgLeftAlign;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *followBtnLeftAlign;

@end

@implementation ZDCFAddPersonView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.whiteBg setClipsToBounds:YES];
    [self.whiteBg.layer setCornerRadius:5.0];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (rect.size.width <= 320) {
        _whiteBgLeftAlign.constant = _whiteBgLeftAlign.constant - 45;
        _followBtnLeftAlign.constant = _followBtnLeftAlign.constant - 45;
    }
    if (rect.size.width >= 414) {
        _whiteBgLeftAlign.constant = _whiteBgLeftAlign.constant + 45;
        _followBtnLeftAlign.constant = _followBtnLeftAlign.constant + 45;
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL temp = [userDefaultes boolForKey:@"ZDCFAddPersonLearned"];
    if (temp == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"隐私政策" message:@"关注别的同学的课程可能会导致隐私权争议，请谨慎使用这一功能。由于人民大学校园网隐私政策调整，未来RUC追课的这个功能可能受限。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
        [userDefaultes setBool:YES forKey:@"ZDCFAddPersonLearned"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)query:(id)sender {
    [self.nameLabel resignFirstResponder];
    [SVProgressHUD showWithStatus:@"正在查询学生目录"];
    self.StudentArray = [[NSMutableArray alloc] init];
    
    if ([_nameLabel.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请输入学号或者全名。" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://123.56.40.174/ClassCatcher/getStudentCode.aspx?querys=%@",_nameLabel.text];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [SVProgressHUD dismiss];
            if ([responseObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                for (NSDictionary *dic in responseObject[@"data"]) {
                    ZDCFStudentInfoObj *newStd = [ZDCFStudentInfoObj new];
                    newStd.name = dic[@"name"];
                    newStd.ssid = dic[@"ssid"];
                    newStd.school = dic[@"school"];
                    newStd.code = dic[@"code"];
                    [self.StudentArray addObject:newStd];
                }
                [self displaySelectionSheet];
            }else{
                if (![responseObject[@"errorMsg"] isKindOfClass:[NSNull class]]) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误数据" message:responseObject[@"errorMsg"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [av show];
                }else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误数据" message:@"服务器返回了未知错误，可能是失去了网络连接。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [av show];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误数据" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [av show];
        }];
    }

}

-(void)displaySelectionSheet{
    UIActionSheet *actionSheet;
    if (self.StudentArray.count == 1) {
        ZDCFStudentInfoObj *stu = self.StudentArray[0];
        NSString *displayName = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
        actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"您找的是TA吗？"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:displayName,nil];
    }else{
        NSString *display1,*display2,*display3,*display4,*display5;
        display1 = @"没有找到此人";
        ZDCFStudentInfoObj *stu;
        if (self.StudentArray.count > 1) {
            stu = self.StudentArray[0];
            display1 = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
            stu = self.StudentArray[1];
            display2 = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
        }
        if (self.StudentArray.count > 2) {
            stu = self.StudentArray[2];
            display3 = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
        }
        if (self.StudentArray.count > 3) {
            stu = self.StudentArray[3];
            display4 = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
        }
        if (self.StudentArray.count > 4) {
            stu = self.StudentArray[4];
            display3 = [NSString stringWithFormat:@"%@ %@ %@",stu.school,stu.ssid,stu.name];
        }
        actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"TA是下面哪一位？"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:display1,display2,display3,display4,display5,nil];
    }
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUInteger max = _StudentArray.count;
    if (max == buttonIndex) {
        
    }else{
        ZDCFStudentInfoObj *obj = [self.StudentArray objectAtIndex:buttonIndex];
        
        [SVProgressHUD showWithStatus:@"正在获取TA的课程信息"];
        if (!self.tokenVerified) {
            [ZDCFUserActions verifyCurrentTokenWithCallback:^(BOOL suc, NSString *dtl){
                if (suc) {
                    self.tokenVerified = YES;
                    [self catchClassesWithCode:obj.code ssid:@([obj.ssid integerValue]) studentName:obj.name];
                }else {
                    [self showAlertViewWithMsg:@"身份认证失败，需要重新登录"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kZDCFNeedLoginKey
                                                                        object:nil];
                    [SVProgressHUD dismiss];
                }
            }];
        }else{
            [self catchClassesWithCode:obj.code ssid:@([obj.ssid integerValue]) studentName:obj.name];
        }
    }
}

//课程解析算法
-(void)catchClassesWithCode:(NSString *)code ssid:(NSNumber *)ssid studentName:(NSString *)name{
    
    NSDictionary *logPara = @{
                              @"posSsid":[[ZDCFLifeCycleModel getSingleton] ssid],
                              @"negSsid":[NSString stringWithFormat:@"%@",ssid],
                              @"key":@"simpleKey"
                              };
    AFHTTPRequestOperationManager *logManager = [AFHTTPRequestOperationManager manager];
    logManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    [logManager GET:@"http://123.56.40.174/ClassCatcher/loadRelationRecord.aspx" parameters:logPara success:^(AFHTTPRequestOperation *operation, id responseObject) {
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    NSString *url = [NSString stringWithFormat:@"http://v.ruc.edu.cn/educenter/api/users/%@/classes",code];
    NSDictionary *paras = @{
                            @"offset":@0,
                            @"limit":@30,
                            @"type":@"普通课程",
                            @"year":@"2015-2016",
                            @"term":@"春季学期",
                            @"school_domain":@"v.ruc.edu.cn",
                            @"access_token":[[ZDCFLifeCycleModel getSingleton] access_token]
                            };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json", nil];
    [manager GET:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            for (NSDictionary *dic in responseObject[@"data"][@"classes"]) {
                ZDCFCourseRecordModel *record = [ZDCFCourseRecordModel new];
                NSString *classname = [NSString stringWithString:dic[@"name"]];
                record.studentname = name;
                record.ssid = ssid;
                record.startWeek = dic[@"schedule"][@"start_week"];
                record.endWeek = dic[@"schedule"][@"end_week"];
                if ([dic[@"schedule"][@"schedule_weekly"] isKindOfClass:[NSNull class]]) {
                    continue;
                }
                for (NSDictionary *dict in dic[@"schedule"][@"schedule_weekly"]) {
                    ZDCFCourseRecordModel *recordMiddle = [record copy];
                    recordMiddle.weekday = dict[@"day"];
                    recordMiddle.place = [NSString stringWithFormat:@"%@%@",dict[@"building"],dict[@"room"]];
                    for (int i = [dict[@"start_section"] intValue]; i <= [dict[@"end_section"] intValue]; i = i+2) {
                        ZDCFCourseRecordModel *recordToAdd = [recordMiddle copy];
                        recordToAdd.bigclass = @((i+1)/2);
                        if (i == [dict[@"end_section"] intValue]) {
                            recordToAdd.isHalf = YES;
                        }
                        recordToAdd.classname = classname;
                        [[ZDCFDataBaseManager getSingleton] insertACourseRecord:recordToAdd];
                    }
                }
                [self.delegate setNeedRefresh];
            }
            [SVProgressHUD dismiss];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"消息" message:@"你已经成功关注了TA！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [av show];
        }else{
            [SVProgressHUD dismiss];
            [self showAlertViewWithMsg:@"服务器返回了错误的数据，请稍后再试"];
        }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithMsg:error.localizedDescription];
    }];

}

-(void)showAlertViewWithMsg:(NSString *)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.nameLabel isExclusiveTouch]) {
        [self.nameLabel resignFirstResponder];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
