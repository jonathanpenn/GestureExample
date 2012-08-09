/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
 ***/
//
//  PRPCircleGestureRecognizer.h
//  CircleGestureRecognizer
//
//  Created by Paul Warren on 10/03/10.
//  Copyright 2010 Primitive Dog Software. All rights reserved.
//

#import "PRPCircleGestureRecognizer.h"

@implementation PRPCircleGestureRecognizer

@synthesize deviation;
@synthesize center;
@synthesize radius;
@synthesize points;


// Credit - Jeff LeMarche
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
};


- (BOOL) recognizeCircle {
    CGFloat tempRadius;
    CGPoint tempCenter;
    CGFloat xLength = distanceBetweenPoints(highX, lowX);
    CGFloat yLength = distanceBetweenPoints(highY, lowY);
    if (xLength > yLength) {
        tempRadius = xLength/2;
        tempCenter = CGPointMake(lowX.x + (highX.x-lowX.x)/2,
                                 lowX.y + (highX.y-lowX.y)/2);
    } else {
        tempRadius = yLength/2;
        tempCenter = CGPointMake(lowY.x + (highY.x-lowY.x)/2,
                                 lowY.y + (highY.y-lowY.y)/2);
    }
    CGFloat deviant = tempRadius * self.deviation;
    
    CGFloat endDistance =
    distanceBetweenPoints([[self.points objectAtIndex:0] CGPointValue],
                          [[self.points lastObject] CGPointValue]);
    if (endDistance > deviant*2) {
        return NO;
    }
    
    for (NSValue *pointValue in self.points) {
        CGPoint point = [pointValue CGPointValue];
        CGFloat pointRadius = distanceBetweenPoints(point, tempCenter);
        if (abs(pointRadius - tempRadius) > deviant) {
            return NO;
        }
    }
    self.radius = tempRadius;
    self.center = tempCenter;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	if ([self numberOfTouches] != 1) {
		self.state = UIGestureRecognizerStateFailed;
		return;
	}
    self.points = [NSMutableArray array];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    lowX = touchPoint;
    lowY = lowX;
    if (self.deviation == 0) self.deviation = 0.4;
    moved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	if ([self numberOfTouches] != 1) {
		self.state = UIGestureRecognizerStateFailed;
	}
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    if (touchPoint.x > highX.x) highX = touchPoint;
    else if (touchPoint.x < lowX.x) lowX = touchPoint;
    if (touchPoint.y > highY.y) highY = touchPoint;
    else if (touchPoint.y < lowY.y) lowY = touchPoint;
    [self.points addObject:[NSValue valueWithCGPoint:touchPoint]];
    moved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if (self.state == UIGestureRecognizerStatePossible) {
		if (moved && [self recognizeCircle]) {
			self.state = UIGestureRecognizerStateRecognized;
		} else {
			self.state = UIGestureRecognizerStateFailed;
		}
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	[self reset];
	self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
	[super reset];
    highX = CGPointZero;
    lowX = CGPointZero;
    highY = CGPointZero;
    lowY = CGPointZero;
    self.radius = 0;
    self.center = CGPointZero;
}
@end



