//
//  UserLocation.h
//  IndoorLocation
//
//  Created by Rain on 14/11/29.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UserLocation : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, strong) NSMutableArray* positionArray;

- (CGPoint)possibleCenter;
- (CGFloat)possibleRadius;

@end
