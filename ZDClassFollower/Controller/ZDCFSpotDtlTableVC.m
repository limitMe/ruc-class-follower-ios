//
//  ZDCFSpotDtlTableVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFSpotDtlTableVC.h"
#import "ZDCFTimeSpotModel.h"
#import "ZDCFCourseRecordModel.h"
#import "ZDCFRoundHeagimgCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZDCFPersonDtlVC.h"

@interface ZDCFSpotDtlTableVC ()

@property (strong, nonatomic) NSMutableArray *thisSpotArray;
@property (strong ,nonatomic) NSNumber *tempSSID;
@property (strong, nonatomic) NSString *tempName;

@end

@implementation ZDCFSpotDtlTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _thisSpotArray = [NSMutableArray new];
    NSArray *weekdayArray = [[ZDCFTimeSpotModel getSingleton] timeSpotArray][_selectedIndexPath.section - 1];
    NSMutableSet *tempSet = weekdayArray[_selectedIndexPath.row];
    for (ZDCFCourseRecordModel *model in tempSet) {
        [_thisSpotArray addObject:model];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _thisSpotArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDCFRoundHeagimgCell *cell = (ZDCFRoundHeagimgCell *)[tableView dequeueReusableCellWithIdentifier:@"spotCell" forIndexPath:indexPath];
    ZDCFCourseRecordModel *model = [_thisSpotArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@在上%@",model.studentname,model.classname];
    cell.dtlLabel.text = model.place;
    
    /*
    if (model.ssid < [NSNumber numberWithLong: 20150000000]) {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://portal.ruc.edu.cn/idc/photo/%@.jpg",model.ssid]];
        [cell.headPic setImageWithURL:imageURL];
    }*/
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZDCFCourseRecordModel *model = [_thisSpotArray objectAtIndex:indexPath.row];
    _tempSSID = model.ssid;
    _tempName = model.studentname;
    [self performSegueWithIdentifier:@"toPersonDtlVC" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toPersonDtlVC"]) {
        ZDCFPersonDtlVC *destination = (ZDCFPersonDtlVC *)[segue destinationViewController];
        destination.ssid = _tempSSID;
        destination.name = _tempName;
    }
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
