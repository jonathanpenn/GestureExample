//
//  CMNRightBezelGestureRecognizer.m
//  GestureExample
//
//  Created by Jonathan Penn on 10/20/12.
//  Copyright (c) 2012 Navel Labs. All rights reserved.
//

#import "CMNRightBezelSwipeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CMNRightBezelSwipeGestureRecognizer {
    CGPoint startPoint;
    NSTimer *expireTimer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    startPoint = [[touches anyObject] locationInView:self.view];
    if ([self pointIsNearRightBezel:startPoint]) {
        [expireTimer invalidate];
        expireTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target:self
                                                     selector:@selector(gestureExpired)
                                                     userInfo:nil
                                                      repeats:NO];
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    CGPoint newPoint = [[touches anyObject] locationInView:self.view];

    if ([self pointIsFarStraightLeftOfBezel:newPoint]) {
        [expireTimer invalidate];
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [expireTimer invalidate];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [expireTimer invalidate];
    self.state = UIGestureRecognizerStateFailed;
}


#pragma mark - Helper Methods For Clarity

/// Called when the timer triggers
- (void)gestureExpired
{
    self.state = UIGestureRecognizerStateFailed;
}

- (BOOL)pointIsNearRightBezel:(CGPoint)point
{
    return abs(point.x - self.view.bounds.size.width) < 10;
}

- (BOOL)pointIsFarStraightLeftOfBezel:(CGPoint)point
{
    return abs(point.x - startPoint.x) > 100 && abs(point.y - startPoint.y) < 20;
}

@end
