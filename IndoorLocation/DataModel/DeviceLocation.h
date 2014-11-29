//
//  DeviceLocations.h
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "DistanceFromIBeacon.h"

@interface DeviceLocation : JSONModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) NSArray<DistanceFromIBeacon>  * location;


@end
