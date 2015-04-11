//
//  WTViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTViewController.h"
#import "WTManager.h"

@interface WTViewController ()

@end

@implementation WTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWeatherInfo];
}

- (void)getWeatherInfo
{
    [WTManager downloadDataForCity:@"Moscow" withCompletionHandler:^(NSDictionary *result) {
//        NSLog(@"%@", result);
        NSLog(@"%@", result[@"main"]);
    }];
}

@end
