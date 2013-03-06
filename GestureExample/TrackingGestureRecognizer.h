#import <UIKit/UIKit.h>

// This subclass is special because it transitions to the "Began" state
// immediately on the first touch. The normal pan gesture transitions on
// first touch move, which doesn't work for the tracking behavior we want.

@interface TrackingGestureRecognizer : UIPanGestureRecognizer

@end
