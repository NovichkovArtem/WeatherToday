//
//  WTForecastViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTForecastViewController.h"
#import "WTManager.h"

@interface WTForecastViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *forcastList;

@end

@implementation WTForecastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WTManager downloadForecastForCity:self.cityName
                 withCompletionHandler:^(NSDictionary *result) {
                     self.forcastList = result[@"list"];
                     [self.tableView reloadData];
                 }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forcastList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *temtDict = self.forcastList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@° C", temtDict[@"main"][@"temp"]];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM.dd, HH"];
    
    
    NSString *dateString = [dateFormat stringFromDate:temtDict[@"dt"]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ hours", dateString];
    return cell;
}

@end
