//
//  WTCitiesViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTCitiesViewController.h"

@interface WTCitiesViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *cities;

@end

@implementation WTCitiesViewController

- (void)viewDidLoad
{
    self.cities = [NSMutableArray arrayWithObjects:@"Moscow", @"Petersburg", nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.cities[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
