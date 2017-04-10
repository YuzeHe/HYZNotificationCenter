//
//  YZNotificationCenter.h
//  YZNotificationCenter
//
//  Created by heyuze on 16/2/24.
//  Copyright © 2016年 hyz. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface YZNotificationCenter : NSObject

// 单例
+ (instancetype)defaultCenter;


// 监听通知
- (void)addObserver:(NSObject *)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;


// 发送通知
- (void)postNotificationName:(NSString *)aName object:(id)anObject;



@end
