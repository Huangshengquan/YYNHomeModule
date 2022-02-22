//
//  XCProgress.m
//  Pedometer
//
//  Created by 黄盛全 on 2020/12/24.
//  Copyright © 2020 黄盛全. All rights reserved.
//

#import "XCProgress.h"



@implementation XCProgress

static XCProgress *_XCProgress = nil;

+ (XCProgress *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _XCProgress = [[self alloc] init];
    });
    return _XCProgress;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _XCProgress = [super allocWithZone:zone];
    });
    return _XCProgress;
}


- (id)copyWithZone:(NSZone *)zone
{
    return _XCProgress;
}

///菊花代理
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (_xcProgress) {
        _xcProgress.delegate=nil;
        [_xcProgress removeFromSuperview];
        _xcProgress=nil;
    }
    
}

///显示菊花，title为文字
- (void)showHudInView:(UIView *)tempView title:(NSString *)title
{
    if (_xcProgress) {
        _xcProgress.delegate=nil;
        [_xcProgress removeFromSuperview];
        _xcProgress=nil;
    }
    _xcProgress = [[MBProgressHUD alloc]init];
    _xcProgress.minSize = CGSizeMake(100, 80);
    [tempView addSubview:_xcProgress];
    
    _xcProgress.label.text = title;
    if (!title || [title isEqualToString:@""]) {
        _xcProgress.label.text = @"加载中";
    }
    
    _xcProgress.bezelView.color = UIColor.blackColor;
    ///菊花与文字颜色
//    _xcProgress.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];

    _xcProgress.margin = 13;
    _xcProgress.label.font = [UIFont boldSystemFontOfSize:12];

    _xcProgress.delegate =self;
    [_xcProgress showAnimated:YES];
    
    [self hideHudAfterTime:300];
}

///隐藏菊花，time是延迟消失时间
- (void)hideHudAfterTime:(NSTimeInterval)time
{
    if (_xcProgress) {
        [_xcProgress hideAnimated:YES afterDelay:time];
    }

}




@end
