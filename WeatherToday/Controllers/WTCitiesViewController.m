//
//  WTCitiesViewController.m
//  WeatherToday
//
//  Created by Артем on 11.04.15.
//  Copyright (c) 2015 Artem Novichkov. All rights reserved.
//

#import "WTCitiesViewController.h"
#import "WTAppDelegate.h"

@interface WTCitiesViewController()
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *cities;

@end

@implementation WTCitiesViewController

- (void)viewDidLoad
{
    [self loadCitiesList];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self
                                    action:@selector(AddCity:)];
    self.navigationItem.leftBarButtonItem = addButton;
}

- (void)loadCitiesList
{
    self.cities = [@[] mutableCopy];
    WTAppDelegate *appDelegate = (WTAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    NSArray *array = [context executeFetchRequest:request
                                            error:nil];
    for (NSManagedObject *object in array) {
        [self.cities addObject:[object valueForKey:@"name"]];
    }
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

- (void)AddCity:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter city name", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Add city"
                                              otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WTAppDelegate *appDelegate = (WTAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *cityName = [[alertView textFieldAtIndex:0] text];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"City"
                                                            inManagedObjectContext:context];
    [object setValue:cityName
              forKey:@"name"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    [self loadCitiesList];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate  respondsToSelector:@selector(currentCityChanged:)]) {
        [self.delegate currentCityChanged:self.cities[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
