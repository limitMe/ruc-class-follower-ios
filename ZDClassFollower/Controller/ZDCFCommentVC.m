//
//  ZDCFCommentVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/25.
//  Copyright © 2015年 zhongdian. All rights reserved.
//

#import "ZDCFCommentVC.h"
#import "ZDCFLifeCycleModel.h"
#import "AFNetworking/AFNetworking.h"

@interface ZDCFCommentVC ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ZDCFCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.layer.cornerRadius = 5.0;
    _textView.layer.masksToBounds = YES;
    //textview.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIColor *customColor  = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:0.5];
    _textView.layer.borderColor = customColor.CGColor;
    _textView.layer.borderWidth = 1.0;
    //_textView.contentInset = UIEdgeInsetsMake(16.0, 8.0, 16.0, 8.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    ZDCFLifeCycleModel *model = [ZDCFLifeCycleModel getSingleton];
    if (!_negSSID || !model.ssid || ![_textView.text isEqualToString:@""]) {
        NSDictionary *Para = @{
                                  @"posSsid":[model ssid],
                                  @"negSsid":_negSSID,
                                  @"comment":_textView.text,
                                  @"key":@"commentKey"
                                  };
        AFHTTPRequestOperationManager *logManager = [AFHTTPRequestOperationManager manager];
        logManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json", nil];
        [logManager GET:@"http://123.56.40.174/ClassCatcher/loadStudentComment.aspx" parameters:Para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self showAlertViewWithMsg:@"已成功提交到服务器"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlertViewWithMsg:[NSString stringWithFormat:@"发生了以下错误:%@",error.localizedDescription]];
        }];
    }else{
        [self showAlertViewWithMsg:@"请确保您已登陆，并且填写了评论内容。"];
    }
}

-(void)showAlertViewWithMsg:(NSString *)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"信息" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [av show];
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
