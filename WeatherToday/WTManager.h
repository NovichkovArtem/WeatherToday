//
//  WTManager.h
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTManager : NSObject

+ (void)downloadDataForCity:(NSString *)city withCompletionHandler:(void (^)(NSDictionary *result))completionHandler;

@end
