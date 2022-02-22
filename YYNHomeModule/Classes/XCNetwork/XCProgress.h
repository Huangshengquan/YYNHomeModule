//
//  XCProgress.h
//  Pedometer
//
//  Created by 黄盛全 on 2020/12/24.
//  Copyright © 2020 黄盛全. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


NS_ASSUME_NONNULL_BEGIN

#define XCHud [XCProgress sharedInstance]

@interface XCProgress : NSObject <MBProgressHUDDelegate>

+ (XCProgress *)sharedInstance;//构造单例

///菊花
@property (nonatomic , strong) MBProgressHUD *xcProgress;

//菊花代理
- (void)hudWasHidden:(MBProgressHUD *)hud;


///显示菊花，title为文字
- (void)showHudInView:(UIView *)tempView title:(NSString *)title;

///隐藏菊花，time是延迟消失时间
- (void)hideHudAfterTime:(NSTimeInterval)time;






@end

NS_ASSUME_NONNULL_END
