//
//  Caculator.h
//  IndoorLocation
//
//  Created by Olivier on 11/28/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caculator : NSObject

- (NSNumber *) meanOf:(NSArray *)array;
- (NSNumber *) varianceOf:(NSArray *)array;
- (NSNumber *) standardDeviationOf:(NSArray *)array;
- (NSMutableArray *) sortAsMinToMax:(NSMutableArray *)unsortedDataArray;
- (NSArray *) maxesOf:(NSMutableArray *)array numberOfReturn :(NSInteger) num;
- (NSArray *) minsOf:(NSMutableArray *)array numberOfReturn :(NSInteger) num;
- (NSArray *) closestNumbers:(NSMutableArray *)array numberOfReturn :(NSInteger) num;

@end
