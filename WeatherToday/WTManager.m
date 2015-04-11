//
//  WTManager.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTManager.h"

NSString *const kOpenWeatherAPIKey = @"a4e963e76122311fd7fd4f6bbd95362f";

@implementation WTManager

+ (void)downloadCurrentWeatherForCity:(NSString *)city withCompletionHandler:(void (^)(NSDictionary *result))completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@", city, kOpenWeatherAPIKey];
    NSURL *url = [NSURL URLWithString:URLString];
    [self downloadDataForURL:url
       withCompletionHandler:completionHandler];
}
+ (void)downloadForecastForCity:(NSString *)city withCompletionHandler:(void (^)(NSDictionary *result))completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@&APPID=%@", city, kOpenWeatherAPIKey];
    NSURL *url = [NSURL URLWithString:URLString];
    [self downloadDataForURL:url
       withCompletionHandler:completionHandler];
}

+ (void)downloadDataForURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *result))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSError *error = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&error];
            res = [self convertResult:res];
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completionHandler(res);
                }];
            }
        }
    }];
    [task resume];
}

+ (NSDictionary *)convertResult:(NSDictionary *) res {
    
    NSMutableDictionary *dic = [res mutableCopy];
    
    NSMutableDictionary *main = [[dic objectForKey:@"main"] mutableCopy];
    if (main) {
        main[@"temp"] = [self convertTemp:main[@"temp"]];
        main[@"temp_min"] = [self convertTemp:main[@"temp_min"]];
        main[@"temp_max"] = [self convertTemp:main[@"temp_max"]];
        
        dic[@"main"] = [main copy];
    }
    
    NSMutableDictionary *temp = [[dic objectForKey:@"temp"] mutableCopy];
    if (temp) {
        temp[@"day"] = [self convertTemp:temp[@"day"]];
        temp[@"eve"] = [self convertTemp:temp[@"eve"]];
        temp[@"max"] = [self convertTemp:temp[@"max"]];
        temp[@"min"] = [self convertTemp:temp[@"min"]];
        temp[@"morn"] = [self convertTemp:temp[@"morn"]];
        temp[@"night"] = [self convertTemp:temp[@"night"]];
        
        dic[@"temp"] = [temp copy];
    }
    
    NSMutableDictionary *sys = [[dic objectForKey:@"sys"] mutableCopy];
    if (sys) {
        sys[@"sunrise"] = [self convertToDate: sys[@"sunrise"]];
        sys[@"sunset"] = [self convertToDate: sys[@"sunset"]];
        
        dic[@"sys"] = [sys copy];
    }
    
    NSMutableArray *list = [[dic objectForKey:@"list"] mutableCopy];
    if (list) {
        for (int i = 0; i < list.count; i++) {
            [list replaceObjectAtIndex:i withObject:[self convertResult: list[i]]];
        }
        dic[@"list"] = [list copy];
    }
    
    dic[@"dt"] = [self convertToDate:dic[@"dt"]];
    
    return [dic copy];
}

+ (NSString *)convertTemp:(NSNumber *)temp
{
    return [NSString stringWithFormat:@"%.f", temp.floatValue - 273.15];
}

+ (NSDate *)convertToDate:(NSNumber *)num
{
    return [NSDate dateWithTimeIntervalSince1970:num.intValue];
}


@end
