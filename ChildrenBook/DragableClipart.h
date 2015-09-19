//
//  DragableClipart.h
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/17/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct SPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} SPUserResizableViewAnchorPoint;

@interface DragableClipart : UIImageView
{
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    SPUserResizableViewAnchorPoint anchorPoint;
}
@property (nonatomic, assign) UIView *contentView;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;
// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

@end
