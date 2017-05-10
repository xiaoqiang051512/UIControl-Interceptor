//
//  UIControl+Interceptor.h
//  ControlInterceptor
//
//  Created by 刘志伟 on 2017/5/10.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InterceptType){
    
    InterceptType_Normal = 0,//正常状况下
    InterceptType_NeedLogin = 1,//需要登录状况
    InterceptType_NeedVerify = 2,//需要认证
    InterceptType_NeedCompleteInfomation = 3,//需要晚上资料
};

@interface UIControl (Interceptor)

@property (assign, nonatomic) InterceptType type;//需要拦截的类型

@property (copy, nonatomic) void (^interceptBlock)(InterceptType type);//暴露被拦截的类型

@end
