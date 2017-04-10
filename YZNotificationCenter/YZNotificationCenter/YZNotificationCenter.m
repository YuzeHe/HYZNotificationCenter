//
//  YZNotificationCenter.m
//  YZNotificationCenter
//
//  Created by heyuze on 16/2/24.
//  Copyright © 2016年 hyz. All rights reserved.
//


#import "YZNotificationCenter.h"
#import "YZNotification.h"

#import <objc/runtime.h>
#import <objc/message.h>




#pragma mark - 
#pragma mark 类扩展

@interface YZNotificationCenter ()

// 所有的观察者对象
@property (nonatomic, strong) NSMutableArray *observers;
// 观察信息（观察者对象为key,通知作为value）
@property (nonatomic, strong) NSMutableDictionary *observerInfo;

@end





#pragma mark -
#pragma mark 类实现

@implementation YZNotificationCenter
//    [NSNotificationCenter defaultCenter]


#pragma mark - 懒加载

// observers
- (NSMutableArray *)observers
{
    if(_observers) return _observers;
    
    _observers = [NSMutableArray array];
    return _observers;
}

// observersInfo
- (NSMutableDictionary *)observerInfo
{
    if (_observerInfo) return _observerInfo;
    
    _observerInfo = [[NSMutableDictionary alloc]init];
    return _observerInfo;
}




#pragma mark - YZNotificationCenter实现方法

// 单例实现
+ (instancetype)defaultCenter
{
    static YZNotificationCenter *_notificationCenter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _notificationCenter = [[YZNotificationCenter alloc]init];
    });
    
    return _notificationCenter;
}


// 发送通知
- (void)postNotificationName:(NSString *)aName object:(id)anObject
{
    NSString *notificationName = aName;
    
    // 遍历observerInfo，找到监听此通知的观察者
    for (NSMutableArray *notifications in self.observerInfo.allValues)
    {
        for (YZNotification *notification in notifications)
        {
            // 如果观察者监听此方法，使其强行调用KVO监听调用方法
            if (notification.name == notificationName)
            {
                //获取keyPath
                const char *keyPathName = [notification.name UTF8String];
                // 使用runtime拿到我们动态添加进去的属性
                int keyPathValue = (int)objc_getAssociatedObject(notification.observer, &keyPathName);
                keyPathValue ++;  //只要随意改变我们监听的动态添加进去的属性，KVO就会自动调用我们监听通知所调用的方法
            }
        }
    }
    
}


// 监听通知
- (void)addObserver:(NSObject *)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
{
    // 检测观察者是否存在（存在就不处理，不存在添加进观察者数组）
    if (![self cheakObserverExist:observer])
    {
        // 把观察者添加进observers
        [self.observers addObject:observer];
        
        // 创建一个可变数组，保存一个观察者的所有通知
        NSMutableArray *notifications = [NSMutableArray array];
        [self.observerInfo setValue:notifications forKey:observer.description];
    }
    
    // 创建通知，设置通知名和通知执行的方法
    YZNotification *notification = [[YZNotification alloc]init];
    notification.name = aName;
    notification.selectorStr = NSStringFromSelector(aSelector);
    notification.observer = observer;
    
    // 从observersInfo取到观察者对应的通知数组
    NSMutableArray *notifications = [self.observerInfo objectForKey:observer.description];
    // 把当前通知添加进notifications
    [notifications addObject:notification];
    
    // 用runtime动态给观察者对象添加一个int属性，属性名为notification.name
    const char *keyPathName = [notification.name UTF8String];
    objc_setAssociatedObject(observer, &keyPathName, 0, OBJC_ASSOCIATION_ASSIGN);
    
    // 通过KVO观察新增加的属性
    [observer addObserver:self forKeyPath: [NSString stringWithUTF8String:keyPathName] options:NSKeyValueObservingOptionNew context:nil];
}


// 检测观察者是否存在方法
- (BOOL)cheakObserverExist:(NSObject *)observer
{
    // 取出observerInfo所有的key（观察者对象）
    NSArray *arr = [self.observerInfo allKeys];
    // 判断当前observer是否存在（不存在则添加进observers）
    if ([arr containsObject:observer.description])
    {
        return YES;
    }
    
    return NO;
}




#pragma mark - KVO监听方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSString *notificationName = keyPath;
    
    // 遍历observerInfo，如果有当前接收的notificationName，则执行对应的方法
    for (NSMutableArray *notifications in self.observerInfo.allValues)
    {
        for (YZNotification *notification in notifications)
        {
            if (notification.name == notificationName)
            {
//                SEL sel = notification.selectorStr
                // 取到观察者对象
                NSObject *observer = notification.observer;
                // 取到执行方法
                SEL sel = NSSelectorFromString(notification.selectorStr);
                // 观察者执行对应的执行方法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [observer performSelector:sel];
#pragma clang diagnostic pop
            }
        }
    }
}







@end
