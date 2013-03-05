#import "CMNDisplayViewController.h"
#import "TrackingGestureRecognizer.h"
#import "PRPCircleGestureRecognizer.h"
#import "CMNBezelSwipeGestureRecognizer.h"

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

@end

@implementation CMNDisplayViewController
{
    TrackingGestureRecognizer *_trackingRecognizer;
    UITapGestureRecognizer *_tapRecognizer;
    UILongPressGestureRecognizer *_longPressRecognizer;
    UISwipeGestureRecognizer *_swipeRecognizer;
    UIRotationGestureRecognizer *_rotationRecognizer;
    UIPinchGestureRecognizer *_pinchRecognizer;
    CMNBezelSwipeGestureRecognizer *_bezelSwipeRecognizer;
    PRPCircleGestureRecognizer *_circleRecognizer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clearFields];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupGestureRecognizers];
}


#pragma mark - Setup

- (void)setupGestureRecognizers
{
    _trackingRecognizer = [[TrackingGestureRecognizer alloc] initWithTarget:self action:@selector(trackingRecognizerFired:)];
    [self.view addGestureRecognizer:_trackingRecognizer];
    _trackingRecognizer.delegate = self;

//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerFired:)];
//    [self.view addGestureRecognizer:_tapRecognizer];
//    [_tapRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizerFired:)];
//    [self.view addGestureRecognizer:_longPressRecognizer];
//    [_longPressRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizerFired:)];
//    _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:_swipeRecognizer];
//    [_swipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRecognizerFired:)];
//    [self.view addGestureRecognizer:_rotationRecognizer];
//    [_rotationRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRecognizerFired:)];
//    [self.view addGestureRecognizer:_pinchRecognizer];
//    [_pinchRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    _rotationRecognizer.delegate = self;
//    _pinchRecognizer.delegate = self;
//
//    _circleRecognizer = [[PRPCircleGestureRecognizer alloc] initWithTarget:self action:@selector(circleRecognizerFired:)];
//    [self.view addGestureRecognizer:_circleRecognizer];
//    [_circleRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//
//    // Adding this to the *window*
//    _bezelSwipeRecognizer = [[CMNBezelSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bezelRecognizerFired:)];
//    [self.view.window addGestureRecognizer:_bezelSwipeRecognizer];
//    [_bezelSwipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer == _trackingRecognizer || otherGestureRecognizer == _trackingRecognizer;

//    return (gestureRecognizer == _trackingRecognizer || otherGestureRecognizer == _trackingRecognizer)
//        || (gestureRecognizer == _rotationRecognizer && otherGestureRecognizer == _pinchRecognizer)
//        || (gestureRecognizer == _pinchRecognizer && otherGestureRecognizer == _rotationRecognizer);
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

- (void)bezelRecognizerFired:(CMNBezelSwipeGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Bezel!"];
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

    if (recognizer == _tapRecognizer) {
        self.tapStateLabel.text = stateName;
    } else if (recognizer == _longPressRecognizer) {
        self.longPressStateLabel.text = stateName;
    } else if (recognizer == _swipeRecognizer) {
        self.swipeStateLabel.text = stateName;
    } else if (recognizer == _rotationRecognizer) {
        self.rotationStateLabel.text = stateName;
    } else if (recognizer == _pinchRecognizer) {
        self.pinchStateLabel.text = stateName;
    } else if (recognizer == _bezelSwipeRecognizer) {
        self.bezelSwipeLabel.text = stateName;
    } else if (recognizer == _circleRecognizer) {
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

@end
