//
//  LocationViewController.m
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import "LocationViewController.h"

#import "DistanceFromIBeacon.h"
#import "Position.h"

#import "LocationBussiness.h"
#import "LocationUploader.h"
#import "MacroDefine.h"
#import "AppDelegate.h"

@interface LocationViewController ()

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLBeaconRegion* region;

@property (nonatomic, strong) NSMutableArray * receiveArr;
@property (nonatomic, strong) DeviceLocation* deviceLocation;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.receiveArr = [[NSMutableArray alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUID];
    CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"IDDD"];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    self.region = beaconRegion;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startRangingBeaconsInRegion:self.region];
 
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.timer) {
        dispatch_source_set_timer(self.timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), 2 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (nil == self.deviceLocation) {
                return;
            }
            LocationUploader * uploader = [[LocationUploader alloc] init];
            
            [uploader uploadLocation:self.deviceLocation resBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString* res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"res=%@", res);
                NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                [self.receiveArr removeAllObjects];
                for (NSDictionary * dic in array) {
                    Position * position = [[Position alloc] initWithDictionary:dic error:nil];
                    [self.receiveArr addObject:position];
                }
            }];
            
        });
        dispatch_resume(self.timer);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSMutableDictionary * sortDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"Immediate":[NSMutableArray new],
                                                                                       @"Near":[NSMutableArray new],
                                                                                       @"Far":[NSMutableArray new]}];
    for (CLBeacon * beacon in beacons) {
        DistanceFromIBeacon * distance = [DistanceFromIBeacon new];
        distance.minor = beacon.minor;
        distance.distance = [[NSNumber alloc] initWithDouble:beacon.accuracy];
        switch (beacon.proximity) {
            case CLProximityImmediate:
                [sortDict[@"Immediate"] addObject:distance];
                break;
            case CLProximityNear:
                [sortDict[@"Near"] addObject:distance];
                break;
            case CLProximityFar:
                [sortDict[@"Far"] addObject:distance];
                break;
            default:
                break;
        }
    }
    NSArray * arr = [LocationBussiness getThe3Beacons:sortDict];
    if (arr.count >= 3) {
        DeviceLocation * deviceLocation = [[DeviceLocation alloc] init];
        deviceLocation.name = @"Rain";
        deviceLocation.uuid = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceUUID;
        deviceLocation.location = arr;
        self.deviceLocation = deviceLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    NSLog(@"Error= %@", [error description]);
}


@end
