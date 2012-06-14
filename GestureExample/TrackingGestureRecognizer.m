#import "TrackingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TrackingGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateBegan;
}

@end
