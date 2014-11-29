//
//  UserLocation.m
//  IndoorLocation
//
//  Created by Rain on 14/11/29.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import "UserLocation.h"
#import "Position.h"
#import "MacroDefine.h"

@implementation UserLocation

- (id)init{
    self = [super init];
    if (self) {
        self.positionArray = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[UserLocation class]]) {
        return NO;
    }
    return [self.uuid isEqual:[(UserLocation*)object uuid]];
}

- (CGPoint)possibleCenter{
    __block float xplus = 0.f;
    __block float yplus = 0.f;
    
    [self.positionArray enumerateObjectsUsingBlock:^(Position* pos, NSUInteger idx, BOOL *stop) {
        xplus += [pos.localX floatValue];
        yplus += [pos.localY floatValue];
    }];
    
    float xavg = xplus/[self.positionArray count];
    float yavg = yplus/[self.positionArray count];
    
    return CGPointMake(xavg, yavg);
}

- (CGFloat)possibleRadius{
    float xavg = [self possibleCenter].x;
    float yavg = [self possibleCenter].y;
    
    __block float xvar = 0.f;
    __block float yvar = 0.f;
    [self.positionArray enumerateObjectsUsingBlock:^(Position* pos, NSUInteger idx, BOOL *stop) {
        xvar += pow([pos.localX floatValue] - xavg, 2.0);
        yvar += pow([pos.localY floatValue] - yavg, 2.0);
    }];
    xvar = sqrt(xvar/[self.positionArray count]);
    yvar = sqrt(yvar/[self.positionArray count]);
    return MAX(xvar, yvar);
}


@end
