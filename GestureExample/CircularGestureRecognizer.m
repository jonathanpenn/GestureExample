#import "CircularGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>



#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return sqrt(deltaX*deltaX + deltaY*deltaY );
}

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat height = second.y - first.y;
	CGFloat width = first.x - second.x;
	CGFloat rads = atan(height/width);
	return radiansToDegrees(rads);
	//degs = degrees(atan((top - bottom)/(right - left)))
}

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
	CGFloat a = line1End.x - line1Start.x;
	CGFloat b = line1End.y - line1Start.y;
	CGFloat c = line2End.x - line2Start.x;
	CGFloat d = line2End.y - line2Start.y;
    
	CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
	return radiansToDegrees(rads);
    
}


@implementation CircularGestureRecognizer
{
    NSMutableArray *_points;
    NSTimeInterval _firstTouchTime;
}

@synthesize reason=_reason;

- (id)initWithTarget:(id)target action:(SEL)action
{
    if ((self = [super initWithTarget:target action:action])) {
        _points = [NSMutableArray array];
    }
    return self;
}

- (void)reset
{
    _points = [NSMutableArray array];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addPointFromTouch:[touches anyObject]];
    _firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addPointFromTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addPointFromTouch:[touches anyObject]];

    if ([self isInProperShape]) {
        self.state = UIGestureRecognizerStateRecognized;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
}

- (BOOL)isInProperShape
{
    // Code adapted from:
    // https://github.com/fmestrone/Circle-Detection-for-iOS/blob/master/Classes/MDCircleGestureRecognizer.m
    //  Created by Federico Mestrone on 28/01/2012.
    //  Copyright (c) 2012 Moodsdesign Ltd. All rights reserved.

    CGPoint firstPoint = CGPointFromString([_points objectAtIndex:0]);
    CGPoint lastPoint = CGPointFromString([_points lastObject]);

    self.reason = nil;

    // Didn't finish close enough to starting point
    if (distanceBetweenPoints(firstPoint, lastPoint) > 50 ) {
        self.reason = @"Didn't close the circle.";
        return NO;
    }
    
    if (_points.count < 6) {
        self.reason = @"Not enough points.";
        return NO;
    }
    
    if ([NSDate timeIntervalSinceReferenceDate] - _firstTouchTime > 3) {
        self.reason = @"Too much time elapsed.";
        return NO;
    }

    CGPoint leftMost = firstPoint;
    NSUInteger leftMostIndex = NSUIntegerMax;
    CGPoint topMost = firstPoint;
    NSUInteger topMostIndex = NSUIntegerMax;
    CGPoint rightMost = firstPoint;
    NSUInteger  rightMostIndex = NSUIntegerMax;
    CGPoint bottomMost = firstPoint;
    NSUInteger bottomMostIndex = NSUIntegerMax;
    
    // Loop through touches and find out if outer limits of the circle
    int index = 0;
    for (NSString *pointString in _points) {
        CGPoint point = CGPointFromString(pointString);
        if (point.x > rightMost.x) {
            rightMost = point;
            rightMostIndex = index;
        }
        if (point.x < leftMost.x) {
            leftMost = point;
            leftMostIndex = index;
        }
        if (point.y > topMost.y) {
            topMost = point;
            topMostIndex = index;
        }
        if (point.y < bottomMost.y) {
            point = bottomMost;
            bottomMostIndex = index;
        }
        index++;
    }
    
    // If startPoint is one of the extreme points, take set it
    if (rightMostIndex == NSUIntegerMax) {
        rightMost = firstPoint;
    }
    if (leftMostIndex == NSUIntegerMax) {
        leftMost = firstPoint;
    }
    if (topMostIndex == NSUIntegerMax) {
        topMost = firstPoint;
    }
    if (bottomMostIndex == NSUIntegerMax) {
        bottomMost = firstPoint;
    }
    
    // Figure out the approx middle of the circle
    CGPoint center = CGPointMake(leftMost.x + (rightMost.x - leftMost.x) / 2.0, bottomMost.y + (topMost.y - bottomMost.y) / 2.0);
    
    // Calculate the radius by looking at the first point and the center
    CGFloat radius = fabsf(distanceBetweenPoints(center, firstPoint));
    
    CGFloat currentAngle = 0.0; 
    BOOL    hasSwitched = NO;
    
    // Start Circle Check=========================================================
    // Make sure all points on circle are within a certain percentage of the radius from the center
    // Make sure that the angle switches direction only once. As we go around the circle,
    //    the angle between the line from the start point to the end point and the line from  the
    //    current point and the end point should go from 0 up to about 180.0, and then come 
    //    back down to 0 (the function returns the smaller of the angles formed by the lines, so
    //    180° is the highest it will return, 0 the lowest. If it switches direction more than once, 
    //    then it's not a circle
    CGFloat radiusVariancePercent = 10;
    CGFloat minRadius = radius - (radius * radiusVariancePercent);
    CGFloat maxRadius = radius + (radius * radiusVariancePercent);
    
    index = 0;
    for (NSString *onePointString in _points) {
        CGPoint onePoint = CGPointFromString(onePointString);
        CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(center, onePoint));
        if (distanceFromRadius < minRadius || distanceFromRadius > maxRadius) {
            self.reason = @"Points don't resemble a circle.";
            return NO;
        }
        
        
        CGFloat pointAngle = angleBetweenLines(firstPoint, center, onePoint, center);
        
        if ((pointAngle > currentAngle && hasSwitched) && (index < _points.count - 3)) {
            self.reason = @"Points overlap too much";
            return NO;
        }
        
        if (pointAngle < currentAngle) {
            if ( !hasSwitched )
                hasSwitched = YES;
        }
        
        currentAngle = pointAngle;
        index++;
    }
    // End Circle Check=========================================================
    
    return YES;
}

- (void)addPointFromTouch:(UITouch *)touch
{
    UIWindow *window = self.view.window;
    CGPoint point = [touch locationInView:window];
    [window convertPoint:point toWindow:nil];
    
    [_points addObject:NSStringFromCGPoint(point)];
}

@end

