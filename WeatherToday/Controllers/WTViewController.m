//
//  WTViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTViewController.h"
#import "WTCitiesViewController.h"
#import "WTManager.h"

@interface WTViewController () <CitiesDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;

@end

@implementation WTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWeatherInfoForCity:@"Moscow"];
}

- (void)getWeatherInfoForCity:(NSString *)city
{
    [WTManager downloadCurrentWeatherForCity:city withCompletionHandler:^(NSDictionary *result) {
        self.infoLabel.text = result[@"name"];
        NSDictionary *tempDict = result[@"main"];
        self.degreeLabel.text = tempDict[@"temp"];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([WTCitiesViewController class])]) {
        UINavigationController *descVC = (UINavigationController *)segue.destinationViewController;
        WTCitiesViewController *citiesVC = descVC.viewControllers[0];
        citiesVC.delegate = self;
    }
}

#pragma mark - CitiesDelegate

- (void)currentCityChanged:(NSString *)city
{
    [self getWeatherInfoForCity:city];
}

@end
