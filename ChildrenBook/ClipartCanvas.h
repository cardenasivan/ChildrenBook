//
//  ClipartCanvas.h
//  ChildrenBook
//
//  Created by Martin, Greg on 9/19/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageCreatorViewController.h"

@interface ClipartCanvas : UIViewController<UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) UIPopoverController* clipartPopoverController;
@property(nonatomic, strong) PageCreatorViewController* clipartParentController;

@end
