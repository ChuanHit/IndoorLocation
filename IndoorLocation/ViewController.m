//
//  ViewController.m
//  IndoorLocation
//
//  Created by Chuan Li on 11/28/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BeaconUUID @"74278BDA-B644-4520-8F0C-720EAF059935"

@interface ViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLBeaconRegion* region;

@property (nonatomic, strong) NSArray* beaconArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    [self check:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)check:(id)sender {
    if (nil == self.region) {
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUID];
        CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"IDDD"];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        self.region = beaconRegion;
    }
    
//    [self.locationManager startMonitoringForRegion:self.region];
    [self.locationManager startRangingBeaconsInRegion:self.region];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    self.beaconArray = beacons;
    
    [self.tableView reloadData];
    
    NSLog(@"count:%lu", (unsigned long)[beacons count]);
    for (int i = 0; i < [beacons count];  ++i) {
        CLBeacon* beacon = [beacons objectAtIndex:i];
        NSLog(@"minor:%d, distace:%f", [beacon.minor intValue], beacon.accuracy);
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    NSLog(@"Error= %@", [error description]);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.beaconArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"CellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    for (UIView* sub in [cell.contentView subviews]){
        [sub removeFromSuperview];
    }
    
    CLBeacon* beacon = [self.beaconArray objectAtIndex:indexPath.row];
    UILabel* minorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
    minorLabel.backgroundColor = [UIColor clearColor];
    minorLabel.font = [UIFont systemFontOfSize:14.f];
    minorLabel.text = [NSString stringWithFormat:@"minor:%d", [beacon.minor intValue]];
    [cell.contentView addSubview:minorLabel];
    
    
    UILabel* disLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 200, 30)];
    disLabel.backgroundColor = [UIColor clearColor];
    disLabel.font = [UIFont systemFontOfSize:14.f];
    disLabel.text = [NSString stringWithFormat:@"distance:%f", beacon.accuracy];
    [cell.contentView addSubview:disLabel];
    
    return cell;
}

@end
