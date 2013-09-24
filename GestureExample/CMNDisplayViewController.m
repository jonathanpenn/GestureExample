#import "CMNDisplayViewController.h"
#import "TrackingGestureRecognizer.h"
#import "PRPCircleGestureRecognizer.h"
#import "CMNRightBezelSwipeGestureRecognizer.h"

@interface CMNDisplayViewController ()
<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *trackingStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tapStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *longPressStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *swipeStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *rotationStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *pinchStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *bezelSwipeLabel;
@property (nonatomic, weak) IBOutlet UILabel *circleStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *triggerMessage;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSMutableArray *fieldsToClear;

@property (nonatomic, strong) TrackingGestureRecognizer *trackingRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) CMNRightBezelSwipeGestureRecognizer *bezelSwipeRecognizer;
@property (nonatomic, strong) PRPCircleGestureRecognizer *circleRecognizer;

@end

@implementation CMNDisplayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearFields];
}


#pragma mark - Setup

- (void)setupGestureRecognizers
{
    self.trackingRecognizer = [[TrackingGestureRecognizer alloc] initWithTarget:self action:@selector(trackingRecognizerFired:)];
    [self.view addGestureRecognizer:self.trackingRecognizer];
    self.trackingRecognizer.delegate = self;

//    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerFired:)];
//    [self.view addGestureRecognizer:self.tapRecognizer];
//    [self.tapRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizerFired:)];
//    [self.view addGestureRecognizer:self.longPressRecognizer];
//    [self.longPressRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizerFired:)];
//    self.swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
//    self.swipeRecognizer.numberOfTouchesRequired = 2;
//    [self.view addGestureRecognizer:self.swipeRecognizer];
//    [self.swipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRecognizerFired:)];
//    [self.view addGestureRecognizer:self.rotationRecognizer];
//    [self.rotationRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizerFired:)];
//    [self.view addGestureRecognizer:self.pinchRecognizer];
//    [self.pinchRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    self.rotationRecognizer.delegate = self;
//    self.pinchRecognizer.delegate = self;
//
//    self.circleRecognizer = [[PRPCircleGestureRecognizer alloc] initWithTarget:self action:@selector(circleRecognizerFired:)];
//    [self.triggerMessage addGestureRecognizer:self.circleRecognizer];
//    [self.circleRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    // Adding this to the *window*
//    self.bezelSwipeRecognizer = [[CMNRightBezelSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bezelRecognizerFired:)];
//    [[[UIApplication sharedApplication] windows][0] addGestureRecognizer:self.bezelSwipeRecognizer];
//    [self.bezelSwipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer == self.trackingRecognizer || otherGestureRecognizer == self.trackingRecognizer;

//    return (gestureRecognizer == self.trackingRecognizer || otherGestureRecognizer == self.trackingRecognizer)
//        || (gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.pinchRecognizer)
//        || (gestureRecognizer == self.pinchRecognizer && otherGestureRecognizer == self.rotationRecognizer);
}


#pragma mark - Gesture Recognizer Actions

- (void)trackingRecognizerFired:(TrackingGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self clearFields];
    }

    NSString *stateText = [self nameFromState:recognizer.state];
    CGPoint point = [recognizer locationInView:self.view];

    self.trackingStateLabel.text = [NSString stringWithFormat:@"{%.f, %.f} %@",
                                    point.x,
                                    point.y,
                                    stateText];
}

- (IBAction)tapRecognizerFired:(UITapGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Tapped!"];
}

- (void)longPressRecognizerFired:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.view];
        NSString *msg = [NSString stringWithFormat:@"Long Press Moved! {%.f, %.f}",
                         point.x,
                         point.y];
        [self triggerMessage:msg];
    } else {
        [self triggerMessage:@"Long Pressed!"];
    }
}

- (void)swipeRecognizerFired:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint swipeStart = [recognizer locationInView:self.view];
    if (swipeStart.x < self.view.bounds.size.width / 2) {
        [self triggerMessage:@"Swiped From Left!"];
    } else {
        [self triggerMessage:@"Swiped From Right!"];
    }
    
    // So, what happens if you swipe to the left on the right side?
}

- (void)rotationRecognizerFired:(UIRotationGestureRecognizer *)recognizer
{
    NSString *text = [NSString stringWithFormat:@"Rotated! (r: %0.2f, v: %0.2f)",
                      recognizer.rotation, recognizer.velocity];
    [self appendTriggerMessage:text];
}

- (void)pinchRecognizerFired:(UIPinchGestureRecognizer *)recognizer
{
    NSString *text = [NSString stringWithFormat:@"Pinched! (s: %0.2f, v: %0.2f)",
                      recognizer.scale, recognizer.velocity];
    [self appendTriggerMessage:text];
}

- (void)bezelRecognizerFired:(CMNRightBezelSwipeGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Bezel!"];
    [self triggerBezelSurprise];
}

- (void)circleRecognizerFired:(PRPCircleGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Circle!"];
}

- (void)triggerMessage:(NSString *)newMessage
{
    self.triggerMessage.text = newMessage;
}

- (void)appendTriggerMessage:(NSString *)newMessage
{
    NSString *original = @"";
    if (self.triggerMessage.text) original = [@"\n" stringByAppendingString:self.triggerMessage.text];
    self.triggerMessage.text = [newMessage stringByAppendingString:original];
}


#pragma mark - Gesture Recognizer State Monitoring

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(UIGestureRecognizer *)recognizer
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self printStateChangeOfGestureRecognizer:recognizer];
}

- (void)printStateChangeOfGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    NSString *stateName = [self nameFromState:recognizer.state];

    if (recognizer == self.tapRecognizer) {
        self.tapStateLabel.text = stateName;
    } else if (recognizer == self.longPressRecognizer) {
        self.longPressStateLabel.text = stateName;
    } else if (recognizer == self.swipeRecognizer) {
        self.swipeStateLabel.text = stateName;
    } else if (recognizer == self.rotationRecognizer) {
        self.rotationStateLabel.text = stateName;
    } else if (recognizer == self.pinchRecognizer) {
        self.pinchStateLabel.text = stateName;
    } else if (recognizer == self.bezelSwipeRecognizer) {
        self.bezelSwipeLabel.text = stateName;
    } else if (recognizer == self.circleRecognizer) {
        self.circleStateLabel.text = stateName;
    } else {
        NSAssert(false, @"Unknown gesture recognizer %@", recognizer);
    }
}

- (NSString *)nameFromState:(UIGestureRecognizerState)state
{
    switch (state) {
        case UIGestureRecognizerStateBegan:
            return @"Began";
        case UIGestureRecognizerStateCancelled:
            return @"Cancelled";
        case UIGestureRecognizerStateChanged:
            return @"Changed";
        case UIGestureRecognizerStateRecognized:
            return @"Recognized";
        case UIGestureRecognizerStateFailed:
            return @"Failed";
        case UIGestureRecognizerStatePossible:
            return @"Possible";
    }
}

- (void)clearFields
{
    for (UILabel *field in self.fieldsToClear) {
        field.text = nil;
    }
}




- (void)triggerBezelSurprise
{
    UIWindow *window = self.view.window;
    UIImage *image = [UIImage imageNamed:@"surprise.png"];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.center = CGPointMake(window.bounds.size.width + view.bounds.size.width,
                              window.bounds.size.height/2);
    [window addSubview:view];

    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = view.center;
        center.x -= view.bounds.size.width;
        view.center = center;
    } completion:^(BOOL finished) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:1 animations:^{
                CGPoint center = view.center;
                center.x += view.bounds.size.width;
                view.center = center;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
    }];
}

@end
