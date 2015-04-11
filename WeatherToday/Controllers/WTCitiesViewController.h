//
//  WTCitiesViewController.h
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitiesDelegate;

@interface WTCitiesViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *managedContext;
@property (nonatomic, weak) id<CitiesDelegate> delegate;

@end

@protocol CitiesDelegate <NSObject>

- (void)currentCityChanged:(NSString *)city;

@end
