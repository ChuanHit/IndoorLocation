//
//  ILUserView.m
//  IndoorLocation
//
//  Created by Chuan Li on 11/29/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import "ILUserView.h"

@implementation ILUserView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.5;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 10.f)];
        self.iconView.backgroundColor = [UIColor blueColor];
        self.iconView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:self.iconView];
    }
    return self;
}

- (void)resetIcon{
    self.iconView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end
