//
//  LocationViewController.m
//  IndoorLocation
//
//  Created by Rain on 14/11/28.
//  Copyright (c) 2014年 Chuan Li. All rights reserved.
//

#import "LocationViewController.h"

#import "DistanceFromIBeacon.h"
#import "Position.h"

#import "LocationBussiness.h"
#import "LocationUploader.h"
#import "MacroDefine.h"
#import "AppDelegate.h"
#import "ILLocationManager.h"
#import "UserLocation.h"
#import "ILUserView.h"

#define  MaxCollection (10)
#define  HeaderSize (40.f)

@interface LocationViewController ()

@property (nonatomic, strong) NSMutableDictionary* userLocDict;
@property (nonatomic, strong) NSMutableDictionary* userViewDict;
@property (nonatomic, strong) dispatch_source_t timer;

- (CGPoint)_convertFromPosition:(CGPoint)pos;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLocDict = [NSMutableDictionary dictionary];
    self.userViewDict = [NSMutableDictionary dictionary];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.timer) {
        dispatch_source_set_timer(self.timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary* newUserViewDict = [NSMutableDictionary dictionary];
                NSMutableDictionary* newUserLocDict = [NSMutableDictionary dictionary];
                for (Position* pos in [[ILLocationManager sharedILLocationManager] userLocations]){
                    UserLocation* loc = [self.userLocDict objectForKey:pos.userId];
                    if (nil == loc) {
                        loc = [[UserLocation alloc] init];
                        loc.uuid = pos.userId;
                    }
                    [loc.positionArray addObject:pos];
                    if ([loc.positionArray count] > MaxCollection) {
                        [loc.positionArray removeObjectAtIndex:0];
                    }
                    
                    [self.userLocDict removeObjectForKey:pos.userId];
                    [newUserLocDict setValue:loc forKey:pos.userId];
                    
                    UIView* dotView = [self.userViewDict objectForKey:pos.userId];
                    if ( nil == dotView ) {
                        UIImageView* dotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HeaderSize, HeaderSize)];
                        dotView.backgroundColor = [UIColor redColor];
                        dotView.layer.cornerRadius = dotView.frame.size.width/2.f;
                        dotView.clipsToBounds = YES;
                        dotView.center = [self _convertFromPosition:loc.possibleCenter];
                        [self.mapImageView addSubview:dotView];
                        [newUserViewDict setValue:dotView forKey:pos.userId];
                    }
                    else{
                        [self.userViewDict removeObjectForKey:pos.userId];
                        [newUserViewDict setValue:dotView forKey:pos.userId];
                        [UIView animateWithDuration:0.3 animations:^{
                            CGPoint center = [self _convertFromPosition:loc.possibleCenter];
                            CGFloat radius = HeaderSize/2;
                            CGRect rect = CGRectMake(center.x-radius, center.y - radius, radius*2, radius*2);
                            dotView.frame = rect;
                            dotView.layer.cornerRadius = dotView.frame.size.width/2.f;
                            dotView.clipsToBounds = YES;
                        }];
                    }
                }
                
                for (UIView* dotView in [self.userViewDict allValues]){
                    [dotView removeFromSuperview];
                }
                
                self.userViewDict = newUserViewDict;
                self.userLocDict = newUserLocDict;
            });
        });
        dispatch_resume(self.timer);
    }
}

- (CGPoint)_convertFromPosition:(CGPoint)pos{
    float xRate = pos.x / OFFICE_X_LENGTH;
    float yRate = pos.y / OFFICE_Y_LENGTH;
    return CGPointMake(self.mapImageView.frame.size.width * yRate ,self.mapImageView.frame.size.height * xRate);
}

@end
