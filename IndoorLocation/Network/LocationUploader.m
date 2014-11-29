//
//  LocationUploader.m
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import "LocationUploader.h"
#import "Position.h"

@implementation LocationUploader

- (BOOL)uploadLocation:(DeviceLocations *)deviceLocaitons resBlock:(void (^)(NSData * data, NSURLResponse *response, NSError *error))response
{
    NSURL * url = [NSURL URLWithString:@"http://172.16.30.195:8000/location"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[deviceLocaitons toDictionary] options:kNilOptions error:nil]; 
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:response];
    [dataTask resume];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.16.30.195:8000/location"]];
//        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"str=%@", str);
//    });
    return YES;
}

@end
