//
//  CanvasVC.h
//  Drawing Hackathon
//
//  Created by Martin, Greg on 9/16/15.
//  Copyright (c) 2015 Martin, Greg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectThemeViewController.h"

@interface CanvasVC : UIViewController <UIAlertViewDelegate>

@property(nonatomic, strong) UIPopoverController* popoverController;
@property(nonatomic, strong) SelectThemeViewController* parentController;

@end
