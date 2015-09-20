//
//  SmoothedBIView.h
//  Drawing Hackathon
//
//  Created by Martin, Greg on 9/15/15.
//  Copyright (c) 2015 Martin, Greg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmoothedBIView : UIView

@property(nonatomic, strong)UIColor* lineColor;
@property(nonatomic)CGFloat lineWidth;

@property(nonatomic, strong)UIImage* incrementalImage;
@end
