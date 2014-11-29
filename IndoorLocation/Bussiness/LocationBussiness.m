//
//  LocationBussiness.m
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import "LocationBussiness.h"
#import "Position.h"

@implementation LocationBussiness

+ (NSArray *)getThe3Beacons:(NSDictionary *)dict
{
    NSMutableArray * getBeacons = [[NSMutableArray alloc] initWithCapacity:3];
    int count = 3;
    NSArray * arr = [dict objectForKey:@"Immediate"];
    if (arr && (count - arr.count > 0)) {
        [getBeacons addObjectsFromArray:arr];
        count = count - (int)arr.count;
    }
    else {
        for (int i = 0; i < 3; i ++) {
            [getBeacons addObject:arr[i]];
        }
        return getBeacons;
    }
    
    arr = [dict objectForKey:@"Near"];
    if (arr && (count - arr.count > 0)) {
        [getBeacons addObjectsFromArray:arr];
    }
    else {
        for (int i = 0; i < 3; i ++) {
            [getBeacons addObject:arr[i]];
        }
        return getBeacons;
    }
    
    arr = [dict objectForKey:@"Far"];
    if (arr && (count - arr.count > 0)) {
        [getBeacons addObjectsFromArray:arr];
    }
    else {
        for (int i = 0; i < 3; i ++) {
            [getBeacons addObject:arr[i]];
        }
        return getBeacons;
    }
    
    return getBeacons;
}

@end
