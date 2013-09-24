//
//  CMNRightBezelPanGestureRecognizer.m
//  GestureExample
//
//  Created by Jonathan on 9/24/13.
//  Copyright (c) 2013 Navel Labs. All rights reserved.
//

#import "CMNRightBezelPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CMNRightBezelPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint startPoint = [[touches anyObject] locationInView:self.view];
    if (![self pointIsNearRightBezel:startPoint]) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}


#pragma mark - Helper Methods For Clarity

- (BOOL)pointIsNearRightBezel:(CGPoint)point
{
    return abs(point.x - self.view.bounds.size.width) < 10;
}

@end
