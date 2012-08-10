#import "CMNDisplayViewController.h"
#import "TrackingGestureRecognizer.h"
#import "PRPCircleGestureRecognizer.h"

@implementation CMNDisplayViewController
{
    TrackingGestureRecognizer *_trackingRecognizer;
    UITapGestureRecognizer *_tapRecognizer;
    UILongPressGestureRecognizer *_longPressRecognizer;
    UISwipeGestureRecognizer *_swipeRecognizer;
    UIRotationGestureRecognizer *_rotationRecognizer;
    PRPCircleGestureRecognizer *_customRecognizer;
}

@synthesize trackingStateLabel=_trackingStateLabel;
@synthesize tapStateLabel=_tapStateLabel;
@synthesize longPressStateLabel=_longPressStateLabel;
@synthesize swipeStateLabel=_swipeXStateLabel;
@synthesize rotationStateLabel=_rotationStateLabel;
@synthesize rotationDataLabel=_rotationDataLabel;
@synthesize customStateLabel=_customStateLabel;
@synthesize triggeredLabel=_triggeredLabel;

@synthesize fieldsToClear=_fieldsToClear;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self clearFields];
    [self setupGestureRecognizers];
}


#pragma mark - Setup

- (void)clearFields
{
    for (UILabel *field in self.fieldsToClear) {
        field.text = nil;
    }
}

- (void)removeDefaultGestureRecognizers
{
    for (UIGestureRecognizer *recognizer in self.tableView.gestureRecognizers) {
        [self.tableView removeGestureRecognizer:recognizer];
    }
}

- (void)setupGestureRecognizers
{
    [self removeDefaultGestureRecognizers];

    _trackingRecognizer = [[TrackingGestureRecognizer alloc] initWithTarget:self action:@selector(trackingRecognizerFired:)];
    [_trackingRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    _trackingRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:_trackingRecognizer];

//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerFired:)];
//    [_tapRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//    _tapRecognizer.delegate = self;
//    [self.tableView addGestureRecognizer:_tapRecognizer];
//    
//    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizerFired:)];
//    [_longPressRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//    _longPressRecognizer.delegate = self;
//    [self.tableView addGestureRecognizer:_longPressRecognizer];
//    
//    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizerFired:)];
//    _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
//    [_swipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//    _swipeRecognizer.delegate = self;
//    [self.tableView addGestureRecognizer:_swipeRecognizer];
//    
//    _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRecognizerFired:)];
//    [_rotationRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//    _rotationRecognizer.delegate = self;
//    [self.tableView addGestureRecognizer:_rotationRecognizer];
//
//    _customRecognizer = [[PRPCircleGestureRecognizer alloc] initWithTarget:self action:@selector(customRecognizerFired:)];
//    [_customRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
//    _customRecognizer.delegate = self;
//    [self.tableView addGestureRecognizer:_customRecognizer];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer == _trackingRecognizer || otherGestureRecognizer == _trackingRecognizer;
}


#pragma mark - Gesture Recognizer Actions

- (void)trackingRecognizerFired:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self clearFields];
        self.trackingStateLabel.text = @"Began";
    }
}

- (void)tapRecognizerFired:(UITapGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Tapped!"];
}

- (void)longPressRecognizerFired:(UILongPressGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Long Pressed!"];
}

- (void)swipeRecognizerFired:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint swipeStart = [recognizer locationInView:self.view];
    if (swipeStart.x < self.view.bounds.size.width / 2) {
        [self triggerMessage:@"Swiped From Left!"];
    } else {
        [self triggerMessage:@"Swiped From Right!"];
    }
}

- (void)rotationRecognizerFired:(UIRotationGestureRecognizer *)recognizer
{
    _rotationDataLabel.text = [NSString stringWithFormat:@"rotation: %0.2f, velocity: %0.2f", recognizer.rotation, recognizer.velocity];
    [self triggerMessage:@"Rotated!"];
}

- (void)customRecognizerFired:(PRPCircleGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Custom!"];
}

- (void)triggerMessage:(NSString *)triggerMessage
{
    _triggeredLabel.text = triggerMessage;
    [self.tableView reloadData];
}


#pragma mark - Gesture Recognizer State Monitoring

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIGestureRecognizer *)recognizer change:(NSDictionary *)change context:(void *)context
{
    [self printStateChangeOfGestureRecognizer:recognizer];
}

- (void)printStateChangeOfGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    NSString *stateName = [self nameFromState:recognizer.state];

    if (recognizer == _trackingRecognizer) {
        self.trackingStateLabel.text = stateName;
    } else if (recognizer == _tapRecognizer) {
        self.tapStateLabel.text = stateName;
    } else if (recognizer == _longPressRecognizer) {
        self.longPressStateLabel.text = stateName;
    } else if (recognizer == _swipeRecognizer) {
        self.swipeStateLabel.text = stateName;
    } else if (recognizer == _rotationRecognizer) {
        self.rotationStateLabel.text = stateName;
    } else if (recognizer == _customRecognizer) {
        self.customStateLabel.text = stateName;
    } else {
        NSAssert(false, @"Unknown gesture recognizer %@", recognizer);
    }

    [self.tableView reloadData];
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


@end
