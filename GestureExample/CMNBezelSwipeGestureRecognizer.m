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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    CGFloat height = self.view.bounds.size.height;

    if (startPoint.y < height - 20) {
        [expireTimer invalidate];
        self.state = UIGestureRecognizerStateFailed;
    } else {
        CGPoint newPoint = [[touches anyObject] locationInView:self.view];

        if (newPoint.y < startPoint.y - (height / 10)) {
            [expireTimer invalidate];
            self.state = UIGestureRecognizerStateRecognized;
        }
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

- (void)gestureExpired
{
    self.state = UIGestureRecognizerStateFailed;
}

@end
