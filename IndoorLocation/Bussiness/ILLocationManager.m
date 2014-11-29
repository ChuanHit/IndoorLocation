//
//  ILLocationManager.m
//  IndoorLocation
//
//  Created by Chuan Li on 11/29/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import "ILLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationUploader.h"
#import "DeviceLocation.h"
#import "Position.h"
#import "DistanceFromIBeacon.h"

#define BeaconUUID @"74278BDA-B644-4520-8F0C-720EAF059935"

@interface ILLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) LocationUploader* uploader;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) NSArray* beaconArray;
@property (nonatomic, strong) DeviceLocation* deviceLocation;

@property (nonatomic, strong) NSString* uuid;

@end

@implementation ILLocationManager
SYNTHESIZE_SINGLETON_FOR_CLASS(ILLocationManager)

- (id)init{
    self = [super init];
    if (self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        self.uuid = [defaults objectForKey:@"LocationUserUUID"];
        if (nil == self.uuid) {
            self.uuid =  [[NSUUID UUID] UUIDString];
            [defaults setObject:self.uuid forKey:@"LocationUserUUID"];
            [defaults synchronize];
        }
    }
    return self;
}

- (void)startMonitor{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUID];
    CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"IDDD"];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)startReport{
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
                NSMutableArray* userLocations = [NSMutableArray array];
                
                for (NSDictionary * dic in array) {
                    Position * position = [[Position alloc] initWithDictionary:dic error:nil];
                    [userLocations addObject:position];
                }
                self.userLocations = userLocations;
            }];
            
        });
        dispatch_resume(self.timer);
    }
}

- (DeviceLocation *)deviceLocation{
    if ([self.beaconArray count] < 3) {
        return nil;
    }
    if ([[self.beaconArray objectAtIndex:2] accuracy] < 0) {
        return nil;
    }
    
    DeviceLocation* dl = [[DeviceLocation alloc] init];
    dl.name = @"Rain";
    dl.uuid = self.uuid;
    
    NSMutableArray* dList = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        CLBeacon* beacon = [self.beaconArray objectAtIndex:i];
        DistanceFromIBeacon* ib = [[DistanceFromIBeacon alloc] init];
        ib.minor = beacon.minor;
        ib.distance = [NSNumber numberWithFloat:beacon.accuracy];
        [dList addObject:ib];
    }
    dl.location = (NSArray<DistanceFromIBeacon> *)[NSArray arrayWithArray:dList];
    
    return dl;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    self.beaconArray = [beacons sortedArrayUsingComparator:^NSComparisonResult(CLBeacon* beacon1, CLBeacon* beacon2) {
        return beacon1.accuracy - beacon2.accuracy;
    }];
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    NSLog(@"Error= %@", [error description]);
}

@end
