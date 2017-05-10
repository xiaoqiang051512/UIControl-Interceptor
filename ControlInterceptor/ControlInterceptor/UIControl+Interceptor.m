//
//  UIControl+Interceptor.m
//  ControlInterceptor
//
//  Created by 刘志伟 on 2017/5/10.
//  Copyright © 2017年 刘志伟. All rights reserved.
//

#import "UIControl+Interceptor.h"
#import "ZAShareUserInfoModel.h"
#import <objc/runtime.h>

static char * typeKey = "Intercept_Type_Key";
static char * intercptTypeBlockKey = "Intercept_Type_Block";

@implementation UIControl (Interceptor)

#pragma mark -  setter 和 getter
- (void)setType:(InterceptType)type{
    
    objc_setAssociatedObject(self, &typeKey, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (InterceptType)type{
    
    NSNumber *typeValue =  (NSNumber *)objc_getAssociatedObject(self, &typeKey);
    
    return typeValue.integerValue;
}

- (void)setInterceptBlock:(void (^)(InterceptType))interceptBlock{
    
    objc_setAssociatedObject(self, &intercptTypeBlockKey, interceptBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(InterceptType))interceptBlock{
    
    return objc_getAssociatedObject(self, &intercptTypeBlockKey);
}

#pragma mark - swizzling Method 这里只有在设置type类型 而且type 类型为需要拦截的试试才进行处理
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        Class class = [self class];
        
        SEL originalSel = @selector(sendAction:to:forEvent:);
        SEL swizzlingSel = @selector(swizzling_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSel);
        Method swizzlingMethod  = class_getInstanceMethod(class, swizzlingSel);
        
        //先判断该类里面是是否有这个方法 通常情况下是有的 防止异常增加这个判断
        BOOL success = class_addMethod(class, originalSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
        if (success) {//没有这个方法的时候
            
            class_replaceMethod(class, swizzlingSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
        } else {//有这个方法的时候
            
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
    });
}

///需要拦截的方法
- (void)swizzling_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    InterceptType type = self.type;
    
    switch (type) {
        case InterceptType_Normal:{//不需要拦截的情况下
        
            [self handNoting:action to:target forEvent:event];
        }
            break;
        case InterceptType_NeedLogin:{//需要判断是否需要拦截非登录的情况下
        
            [self handNeedLogin:action to:target forEvent:event];
        }
            break;
        case InterceptType_NeedVerify:{//判断是否需要拦截非实名认证的情况下
        
            [self handNeedVeryfy:action to:target forEvent:event];
        }
            break;
        case InterceptType_NeedCompleteInfomation:{//判断是否需要完善资料的情况下
        
            [self handNeedCompleteInfomation:action to:target forEvent:event];
        }
            break;
        default:
            break;
    }
}

///不需要处理的情况下
- (void)handNoting:(SEL)action to:(id)target forEvent:(UIEvent *)event{

    [self swizzling_sendAction:action to:target forEvent:event];
}

///处理登录是否需要拦截
- (void)handNeedLogin:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    ZAShareUserInfoModel *userInfoModel = [ZAShareUserInfoModel shareModel];
    
    if (userInfoModel.login) {//登录状态下 不拦截
        
        [self swizzling_sendAction:action to:target forEvent:event];
        
    } else { //非登录状态下 拦截
    
        if (self.interceptBlock) {
            
            self.interceptBlock(InterceptType_NeedLogin);
        }
    }
}


///处理实名认证是否需要拦截
- (void)handNeedVeryfy:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    ZAShareUserInfoModel *userInfoModel = [ZAShareUserInfoModel shareModel];
    
    if (userInfoModel.verity) {//登录状态下 不拦截
        
        [self swizzling_sendAction:action to:target forEvent:event];
        
    } else { //非登录状态下 拦截
        
        if (self.interceptBlock) {
            
            self.interceptBlock(InterceptType_NeedVerify);
        }
    }
}

///处理是否需要完善资料
- (void)handNeedCompleteInfomation:(SEL)action to:(id)target forEvent:(UIEvent *)event{

    ZAShareUserInfoModel *userInfoModel = [ZAShareUserInfoModel shareModel];
    
    if (userInfoModel.finishCompletionInfomation) {//登录状态下 不拦截
        
        [self swizzling_sendAction:action to:target forEvent:event];
        
    } else { //非登录状态下 拦截
        
        if (self.interceptBlock) {
            
            self.interceptBlock(InterceptType_NeedCompleteInfomation);
        }
    }
}

@end
