//
//  PageCreatorViewController.h
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/17/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageCreatorViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

-(void)reloadData;

@end
