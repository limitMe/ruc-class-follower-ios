//
//  ZDCFAgendaTableVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFAgendaTableVC.h"

#import "ZDCFTriInfoCell.h"
#import "ZDCFTimeSpotModel.h"
#import "ZDCFDataBaseManager.h"
#import "ZDCFCourseRecordModel.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ZDCFAddPersonView.h"
#import "ZDCFSpotDtlTableVC.h"

@interface ZDCFAgendaTableVC ()

@property (nonatomic, strong) NSIndexPath *tempIndexPath;

@end

@implementation ZDCFAgendaTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL temp = [userDefaultes boolForKey:@"ZDCFAgendaLearned"];
    if (temp == NO) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请添加关注人" message:@"您似乎没有关注任何同学，点击右上角的加号可以添加小伙伴，即刻关注他们的课程！" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [av show];
        [userDefaultes setBool:YES forKey:@"ZDCFAgendaLearned"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (!_loadedMark) {
        [SVProgressHUD showWithStatus:@"正在加载本地数据"];
        [[ZDCFTimeSpotModel getSingleton] renewTimeSpotArray];
        [[ZDCFDataBaseManager getSingleton] refreshTimeSpotModelWithCallback:^(BOOL suc, NSString *str){
            [self.tableView reloadData];
            _loadedMark = YES;
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZDCFTriInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agendaCell" forIndexPath:indexPath];
    
    [cell.picView setImage:[UIImage imageNamed: [NSString stringWithFormat:@"class%ld",(long)(indexPath.row + 1)] ]];
    
    if (_loadedMark) {
        if (indexPath.section  == 0) {
            cell.titleLabel.text = @"没有课程";
            cell.dtlLabel.text = @"您的关注者当前的课程信息将会展示在这里";
        }else {
            
            NSArray *weekdayArray = [[ZDCFTimeSpotModel getSingleton] timeSpotArray][indexPath.section - 1];
            NSMutableSet *spotArray = weekdayArray[indexPath.row];
            if (spotArray.count == 0) {
                cell.titleLabel.text = [NSString stringWithFormat:@"第%ld大节",indexPath.row + 1];
                cell.dtlLabel.text = @"";
            }else{
                NSMutableSet *names = [NSMutableSet new];
                NSMutableSet *classes = [NSMutableSet new];
                
                //TODO 识别当前week
                for (ZDCFCourseRecordModel *model in spotArray) {
                    if (model.studentname) {
                        [names addObject:model.studentname];
                    }
                    if (model.classname) {
                        [classes addObject:model.classname];
                    }
                }
                
                int i = 0;
                NSString *namesLabelText = @"";
                NSString *classesLabelText = @"";
                
                //学生名字
                for (NSString *str in names) {
                    if (i <= 3) {
                        namesLabelText = [NSString stringWithFormat:@"%@%@、",namesLabelText,str];
                    }
                    i++;
                }
                if ([namesLabelText length] != 0) {
                    namesLabelText = [namesLabelText substringWithRange:NSMakeRange(0, [namesLabelText length] - 1)];
                }
                
                if (i>3) {
                    namesLabelText = [NSString stringWithFormat:@"%@等%d人",namesLabelText,i];
                }
                cell.titleLabel.text = namesLabelText;
                
                for (NSString *str in classes) {
                    classesLabelText = [NSString stringWithFormat:@"%@%@、",classesLabelText,str];
                }
                if ([classesLabelText length] != 0) {
                    classesLabelText = [classesLabelText substringWithRange:NSMakeRange(0, [classesLabelText length] - 1)];
                }
                cell.dtlLabel.text = classesLabelText;
            }
        }
    }
    
    if (indexPath.row == 6) {
        //由于是透明度控制颜色，背景需保持为白色
        [cell.picView.layer setOpacity:0.3];
    }else{
        //Reuse情况下得把这个设置回来
        [cell.picView.layer setOpacity:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section != 0){
        _tempIndexPath = indexPath;
        [self performSegueWithIdentifier:@"toTimeSpotVC" sender:self];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"当前时间";
            break;
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
        case 7:
            return @"星期日";
            break;
            
        default:
            return @"时间之外";
            break;
    }
}

-(void)addPerson{
    [self performSegueWithIdentifier:@"toAddPersonVC" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toAddPersonVC"]) {
        ZDCFAddPersonView *destination = (ZDCFAddPersonView *)[segue destinationViewController];
        destination.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"toTimeSpotVC"]) {
        ZDCFSpotDtlTableVC *destination = (ZDCFSpotDtlTableVC *)[segue destinationViewController];
        destination.selectedIndexPath = _tempIndexPath;
    }
}

-(void)setNeedRefresh{
    _loadedMark = NO;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
