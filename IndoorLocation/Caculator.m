//
//  Caculator.m
//  IndoorLocation
//
//  Created by Olivier on 11/28/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import "Caculator.h"

@implementation Caculator

- (NSNumber *) meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

- (NSNumber *) varianceOf:(NSArray *)array
{
    double mean = [[self meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sumOfSquaredDifferences / [array count]];
}

- (NSNumber *) standardDeviationOf:(NSArray *)array
{
    return [NSNumber numberWithDouble:sqrt([[self varianceOf:array] doubleValue])];
}

- (NSMutableArray *) sortAsMinToMax:(NSMutableArray *)unsortedDataArray
{
    long count = unsortedDataArray.count;
    int i;
    bool swapped = TRUE;
    while (swapped){
        swapped = FALSE;
        for (i=1; i<count;i++)
        {
            if ([unsortedDataArray objectAtIndex:(i-1)] > [unsortedDataArray objectAtIndex:i])
            {
                [unsortedDataArray exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                swapped = TRUE;
            }
        }
    }
    return unsortedDataArray;
}

- (NSArray *) maxesOf:(NSMutableArray *)array numberOfReturn :(NSInteger) num{
    NSArray *sortedArray = [self sortAsMinToMax:array];
    num = num < array.count ? num:array.count;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i =0;i<num;i++) {
        [result setObject:[sortedArray objectAtIndex:(array.count - i)] atIndexedSubscript:i];
    }
    
    return result;
}

- (NSArray *) minsOf:(NSMutableArray *)array numberOfReturn :(NSInteger) num{
    NSArray *sortedArray = [self sortAsMinToMax:array];
    num = num<array.count?num:array.count;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i =0;i<num;i++) {
        [result setObject:[sortedArray objectAtIndex:i] atIndexedSubscript:i];
    }
    
    return result;
}

- (NSArray *) closestNumbers:(NSMutableArray *)array numberOfReturn :(NSInteger) num{
    if(num > [array count]) {
        num = [array count];
    }
    
    double variance = [[self varianceOf:array]doubleValue];
    for(int i =0; i< [array count];i++) {
        NSNumber * number = array[i];
        [array setObject:[[NSNumber alloc] initWithDouble:fabs(variance - [number doubleValue])] atIndexedSubscript:i];
    }
    
    NSMutableArray *sortedArray = [self sortAsMinToMax:array];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(int i = 0;i<sortedArray.count;i++) {
        [result setObject:[sortedArray objectAtIndex:i] atIndexedSubscript:i];
    }
    return result;
}
@end
