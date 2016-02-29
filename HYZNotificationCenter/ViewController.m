//
//  ViewController.m
//  HYZNotificationCenter
//
//  Created by heyuze on 16/2/24.
//  Copyright © 2016年 hyz. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end



@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

//    [NSNotificationCenter defaultCenter]addObserver:<#(nonnull id)#> selector:<#(nonnull SEL)#> name:<#(nullable NSString *)#> object:<#(nullable id)#>
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
