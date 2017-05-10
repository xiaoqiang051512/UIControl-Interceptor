//
//  ZAShareUserInfoModel.h
//  ControlInterceptor
//
//  Created by 刘志伟 on 2017/5/10.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAShareUserInfoModel : NSObject

@property (assign, nonatomic,getter=isLogin) BOOL login;//是否登录
@property (assign, nonatomic,getter=isVerity) BOOL verity;//是否实名认证了
@property (assign, nonatomic) BOOL finishCompletionInfomation;//资料是否完善了

+ (instancetype)shareModel;

@end
