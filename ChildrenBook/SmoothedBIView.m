//
//  SmoothedBIView.m
//  Drawing Hackathon
//
//  Created by Martin, Greg on 9/15/15.
//  Copyright (c) 2015 Martin, Greg. All rights reserved.
//

#import "SmoothedBIView.h"

@implementation SmoothedBIView
{
    UIBezierPath *path;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.incrementalImage = nil;
        self.lineWidth = 2.0;
        [self setMultipleTouchEnabled:NO];
        path = [UIBezierPath bezierPath];
        [self setBackgroundColor:[UIColor whiteColor]];
        [path setLineWidth:self.lineWidth];
        self.lineColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.incrementalImage drawInRect:rect];
    [path setLineWidth:self.lineWidth];
    [self.lineColor setStroke];
    [path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        [self.lineColor setStroke];
        [path setLineWidth:self.lineWidth];
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self drawBitmap];
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [path removeAllPoints];
    ctr = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (!self.incrementalImage) // first time; paint background white
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor clearColor] setFill];
        [rectpath fill];
    }
    if(self.lineColor == [UIColor clearColor])
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.incrementalImage drawAtPoint:CGPointZero];
        
        CGContextAddPath(context, path.CGPath);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 10.0);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextStrokePath(context);
    }
    [self.incrementalImage drawAtPoint:CGPointZero];
    [self.lineColor setStroke];
    [path setLineWidth:self.lineWidth];
    [path stroke];
    [self setBackgroundColor:[UIColor clearColor]];
    self.opaque = NO;
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
