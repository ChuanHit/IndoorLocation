//
//  ILLocationManager.h
//  IndoorLocation
//
//  Created by Chuan Li on 11/29/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesisSingleton.h"

@interface ILLocationManager : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(ILLocationManager)

@property (nonatomic, strong) NSArray* userLocations;

- (void)startReport;
- (void)startMonitor;

@end
