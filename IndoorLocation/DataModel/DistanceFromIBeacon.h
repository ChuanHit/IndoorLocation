//
//  DistanceFromIBeacon.h
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONModel.h"

@protocol DistanceFromIBeacon <NSObject>

@end

@interface DistanceFromIBeacon : JSONModel

@property (nonatomic, strong)   NSNumber * minor;
@property (nonatomic, strong)   NSNumber * distance;
//@property (nonatomic)           CLProximity  proximity;

@end
