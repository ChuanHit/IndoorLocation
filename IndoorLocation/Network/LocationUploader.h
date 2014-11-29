//
//  LocationUploader.h
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceLocation.h"

@interface LocationUploader : NSObject

- (BOOL)uploadLocation:(DeviceLocation *)deviceLocaitons resBlock:(void (^)(NSData * data, NSURLResponse *response, NSError *error))response;

@end
