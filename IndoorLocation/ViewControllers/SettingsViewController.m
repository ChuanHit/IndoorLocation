//
//  SettingsViewController.m
//  IndoorLocation
//
//  Created by Chuan Li on 11/29/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import "SettingsViewController.h"
#import "ILLocationManager.h"
#import "LocationViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Setting";
    
    self.navigationItem.backBarButtonItem = nil;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"UserName"]) {
        [ILLocationManager sharedILLocationManager].userName = [defaults objectForKey:@"UserName"];
        LocationViewController* lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

- (IBAction)saveMe:(id)sender {
    [ILLocationManager sharedILLocationManager].userName = self.textField.text;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.textField.text forKey:@"UserName"];
    [defaults synchronize];
    
    LocationViewController* lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

@end
