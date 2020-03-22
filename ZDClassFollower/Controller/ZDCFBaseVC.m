//
//  ZDCFBaseVC.m
//  ZDClassFollower
//
//  Created by zhongdian on 15/9/23.
//  Copyright (c) 2015年 zhongdian. All rights reserved.
//

#import "ZDCFBaseVC.h"
#import "ZDCFUniversal.h"
#import "ZDCFStoryTransDelegate.h"
#import "ZDCFUserActions.h"

@interface ZDCFBaseVC ()

@property (strong, nonatomic) UIViewController *mainVC;
@property (strong, nonatomic) UIViewController *loginVC;

@end

@implementation ZDCFBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainVC)
                                                 name:kZDCFLoginSuccessfullyKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoginVC)
                                                 name:kZDCFNeedLoginKey
                                               object:nil];
    
    if (![ZDCFUserActions prepareToken]) {
        [self setupLoginViewController];
    }
    else{
        [self setupMainViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Inits
- (UIViewController *)mainVC
{
    if (!_mainVC) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"ZDCFMain" bundle:[NSBundle mainBundle]];
        _mainVC = [mainSB instantiateInitialViewController];
    }
    return _mainVC;
}

- (UIViewController *)loginVC
{
    if (!_loginVC) {
        UIStoryboard *entrySB = [UIStoryboard storyboardWithName:@"ZDCFPush" bundle:[NSBundle mainBundle]];
        _loginVC = [entrySB instantiateInitialViewController];
    }
    return _loginVC;
}

#pragma mark Jump to VC
- (void)setupMainViewController{
    self.mainVC.view.frame = self.view.bounds;
    [self.mainVC willMoveToParentViewController:self];
    [self.view addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];
    [self.mainVC didMoveToParentViewController:self];
}

- (void)setupLoginViewController{
    self.loginVC.view.frame = self.view.bounds;
    [self.loginVC willMoveToParentViewController:self];
    [self.view addSubview:self.loginVC.view];
    [self addChildViewController:self.loginVC];
    [self.loginVC didMoveToParentViewController:self];
}

-(void)showMainVC{
    [self setupMainViewController];
}

-(void)showLoginVC{
    [self setupLoginViewController];
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
