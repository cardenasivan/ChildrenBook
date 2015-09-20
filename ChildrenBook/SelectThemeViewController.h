//
//  SelectThemeViewController.h
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/15/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectThemeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

-(void)reloadData;

@end
