//
//  WTViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTViewController.h"
#import "WTCitiesViewController.h"
#import "WTForecastViewController.h"
#import "WTManager.h"

@interface WTViewController () <CitiesDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;

@end

@implementation WTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = NSLocalizedString(@"Loading", nil);
    self.degreeLabel.hidden = YES;
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    [imageView.superview sendSubviewToBack:imageView];
    [self getWeatherInfoForCity:@"Moscow"];
}

- (void)getWeatherInfoForCity:(NSString *)city
{
    [WTManager downloadCurrentWeatherForCity:city withCompletionHandler:^(NSDictionary *result) {
        self.infoLabel.text = result[@"name"];
        NSDictionary *tempDict = result[@"main"];
        self.degreeLabel.hidden = NO;
        self.degreeLabel.text = [NSString stringWithFormat:@"%@° C", tempDict[@"temp"]];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([WTCitiesViewController class])]) {
        UINavigationController *descVC = (UINavigationController *)segue.destinationViewController;
        WTCitiesViewController *citiesVC = descVC.viewControllers[0];
        citiesVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:NSStringFromClass([WTForecastViewController class])]) {
        UINavigationController *descVC = (UINavigationController *)segue.destinationViewController;
        WTForecastViewController *forecastVC = descVC.viewControllers[0];
        forecastVC.cityName = @"Moscow";
    }
}

#pragma mark - CitiesDelegate

- (void)currentCityChanged:(NSString *)city
{
    self.infoLabel.text = NSLocalizedString(@"Loading", nil);
    self.degreeLabel.hidden = YES;
    [self getWeatherInfoForCity:city];
}

@end
