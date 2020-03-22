//
//  ZDCFPersonDtlVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFPersonDtlVC.h"
#import "ZDCFBigHeadCell.h"
#import "ZDCFClassOnlyCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZDCFSingleStudentModel.h"
#import "ZDCFCourseRecordModel.h"
#import "ZDCFDataBaseManager.h"
#import "ZDCFCommentVC.h"
#import <AFNetworking/AFNetworking.h>
#import "ZDCFSingleCommentObj.h"

@interface ZDCFPersonDtlVC ()<UIActionSheetDelegate>

@property BOOL isloaded;
@property BOOL isCommentLoaded;
@property (strong, nonatomic) NSMutableArray *classes;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation ZDCFPersonDtlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZDCFDataBaseManager *manager = [ZDCFDataBaseManager getSingleton];
    [manager refreshCurrentStudentModelWithSSID:_ssid callback:^(BOOL suc, NSString *str){
        if (suc) {
            _isloaded = YES;
            _classes = [NSMutableArray new];
            ZDCFSingleStudentModel *model = [ZDCFSingleStudentModel getSingleton];
            for (ZDCFCourseRecordModel *record in model.classSet) {
                [_classes addObject:record];
            }
        }
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rewindPerson)];

}

-(void)viewWillAppear:(BOOL)animated{
    self.comments = [NSMutableArray new];
    NSDictionary *logPara = @{
                              @"Ssid":_ssid
                              };
    AFHTTPRequestOperationManager *logManager = [AFHTTPRequestOperationManager manager];
    logManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
    [logManager GET:@"http://123.56.40.174/ClassCatcher/getCommentList.aspx" parameters:logPara success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isCommentLoaded = YES;
            for (NSDictionary *dic in responseObject[@"comments"]) {
                ZDCFSingleCommentObj *obj = [ZDCFSingleCommentObj new];
                obj.posSSID = dic[@"posSSID"];
                obj.negSSID = dic[@"negSSID"];
                obj.content = dic[@"comment"];
                obj.time = dic[@"time"];
                [self.comments addObject:obj];
            }
            [self.tableView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_isloaded) {
            return _classes.count;
        }
        return 1;
    }else if(section == 1){
        if (_isCommentLoaded) {
            return self.comments.count;
        }
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 180.0;
    }else{
        return 60.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        ZDCFBigHeadCell *cell = (ZDCFBigHeadCell *)[tableView dequeueReusableCellWithIdentifier:@"bigHeadCell" forIndexPath:indexPath];
        
        [cell.bigheadPic.layer setCornerRadius:60.0];
        cell.bigheadPic.clipsToBounds = YES;
        NSURL *imageURL;
        if (_ssid > [NSNumber numberWithInt:2013201380]
            && _ssid < [NSNumber numberWithInt:2013201385]) {
            imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://123.56.40.174/ClassCatcher/%@.png",_ssid]];
            [cell.bigheadPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"school"]];
        }else{
            imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://portal.ruc.edu.cn/idc/photo/%@.jpg",_ssid]];
            [cell.bigheadPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"school"]];
        }
        [cell.bigheadPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"school"]];
        cell.nameLabel.text = _name;
        return cell;
    }else if(indexPath.section == 0){
        ZDCFClassOnlyCell *cell = (ZDCFClassOnlyCell *)[tableView dequeueReusableCellWithIdentifier:@"classOnlyCell" forIndexPath:indexPath];
        if (_isloaded) {
            ZDCFCourseRecordModel *record = _classes[indexPath.row-1];
            cell.dtlLabel.text = [NSString stringWithFormat:@"星期%@ 第%@大节 %@",record.weekday,record.bigclass,record.place];
            cell.titleLabel.text = record.classname;
        }
        return cell;
    }else{
        ZDCFClassOnlyCell *cell = (ZDCFClassOnlyCell *)[tableView dequeueReusableCellWithIdentifier:@"classOnlyCell" forIndexPath:indexPath];
        ZDCFSingleCommentObj *obj = (ZDCFSingleCommentObj *)(_comments[indexPath.row]);
        cell.titleLabel.text = obj.posSSID;
        cell.dtlLabel.text = obj.content;
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"TA的课程";
    }else{
        return @"TA的留言";
    }
}

-(void)rewindPerson{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"您想采取什么操作？"
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"取消关注",@"给TA留言",@"关于",nil];
    [actionSheet showInView:self.view];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[ZDCFDataBaseManager getSingleton] deleteStudentWithSSID:_ssid callback:^(BOOL suc, NSString *str){
            if (suc) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"信息" message:@"您已对TA取消关注，重启程序即可生效" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [av show];
            }
        }];
    }else if (buttonIndex == 1){
        [self performSegueWithIdentifier:@"toCommentVC" sender:self];
    }else if (buttonIndex == 2){
        [self performSegueWithIdentifier:@"toAboutVC" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toCommentVC"]) {
        ZDCFCommentVC *destination = (ZDCFCommentVC *)[segue destinationViewController];
        destination.negSSID = [NSString stringWithFormat:@"%@", _ssid];
    }
}

@end
