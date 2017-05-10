//
//  ViewController.m
//  ControlInterceptor
//
//  Created by 刘志伟 on 2017/5/10.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import "ViewController.h"
#import "ZAShareUserInfoModel.h"
#import "UIControl+Interceptor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZAShareUserInfoModel *model = [ZAShareUserInfoModel shareModel];
    model.login = NO;
    model.verity = NO;
    model.finishCompletionInfomation = NO;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(100, 100, 80, 44)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4;
    loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loginBtn.layer.borderWidth = 1.0;
    [loginBtn addTarget:self action:@selector(loginBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    loginBtn.type = InterceptType_NeedLogin;
    loginBtn.interceptBlock = ^(InterceptType type){
        
        NSLog(@"需要先登录");
    };
}

- (void)loginBtnEvent:(UIButton *)btn{
    
    NSLog(@"点击了登录");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
