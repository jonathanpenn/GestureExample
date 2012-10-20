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
    NSTimer *timer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    startPoint = [[touches anyObject] locationInView:self.view];
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    if (startPoint.y < self.view.bounds.size.height - 10) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newPoint = [[touches anyObject] locationInView:self.view];

    if (newPoint.y < startPoint.y - 40) {
        [timer invalidate];
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateRecognized) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
    [timer invalidate];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateFailed;
    [timer invalidate];
}

- (void)timerFired
{
    self.state = UIGestureRecognizerStateFailed;
}

@end
