//
//  ZAShareUserInfoModel.m
//  ControlInterceptor
//
//  Created by 刘志伟 on 2017/5/10.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import "ZAShareUserInfoModel.h"

@implementation ZAShareUserInfoModel

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        
    }
    
    return self;
}

+ (instancetype)shareModel{
    
    static ZAShareUserInfoModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        model = [[ZAShareUserInfoModel alloc] init];
    });
    
    return model;
}

@end
