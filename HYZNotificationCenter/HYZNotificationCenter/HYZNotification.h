//
//  HYZNotification.h
//  HYZNotificationCenter
//
//  Created by heyuze on 16/2/25.
//  Copyright © 2016年 hyz. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface HYZNotification : NSObject

// 通知名
@property (nonatomic, copy) NSString *name;

// 通知携带的对象
@property (nonatomic, strong) NSObject *object;

// 通知的userinfo
@property (nonatomic, strong) NSDictionary *userinfo;

// 接受通知所执行的方法
@property (nonatomic, copy) NSString *selectorStr;

// 通知的观察者对象
@property (nonatomic, strong) NSObject *observer;


@end
