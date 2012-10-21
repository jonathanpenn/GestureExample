//
//  CMNBezelGestureRecognizer.m
//  GestureExample
//
//  Created by Jonathan Penn on 10/20/12.
//  Copyright (c) 2012 Navel Labs. All rights reserved.
//

#import "CMNBezelSwipeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CMNBezelSwipeGestureRecognizer {
    CGPoint startPoint;
    NSTimer *expireTimer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    startPoint = [[touches anyObject] locationInView:self.view];

    [expireTimer invalidate];
    expireTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(gestureExpired)
                                                 userInfo:nil
                                                  repeats:NO];

    if (startPoint.y < self.view.bounds.size.height - 10) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed || self.state == UIGestureRecognizerStateRecognized) return;

    CGPoint newPoint = [[touches anyObject] locationInView:self.view];

    CGFloat height = self.view.bounds.size.height;
    if (newPoint.y < startPoint.y - (height / 10)) {
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
    self.state = UIGestureRecognizerStateFailed;
    [expireTimer invalidate];
}

- (void)gestureExpired
{
    self.state = UIGestureRecognizerStateFailed;
}

@end
