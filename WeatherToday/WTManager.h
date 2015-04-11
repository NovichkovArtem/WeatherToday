//
//  WTManager.h
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTManager : NSObject

+ (void)downloadCurrentWeatherForCity:(NSString *)city withCompletionHandler:(void (^)(NSDictionary *result))completionHandler;
+ (void)downloadForecastForCity:(NSString *)city withCompletionHandler:(void (^)(NSDictionary *result))completionHandler;

@end
