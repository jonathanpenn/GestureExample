#import "TrackingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TrackingGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

@end
