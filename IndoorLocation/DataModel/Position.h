//
//  Position.h
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Position : JSONModel

@property (nonatomic, strong) NSNumber * localX;
@property (nonatomic, strong) NSNumber * localY;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString<Optional>* avatar;

@end

@interface Positions : JSONModel

@property (nonatomic, strong) NSArray * positions;

@end