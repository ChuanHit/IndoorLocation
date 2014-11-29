//
//  SettingsViewController.h
//  IndoorLocation
//
//  Created by Chuan Li on 11/29/14.
//  Copyright (c) 2014 Chuan Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)saveMe:(id)sender;

@end
