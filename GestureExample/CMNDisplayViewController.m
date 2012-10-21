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
@property (weak, nonatomic) IBOutlet UILabel *bezelSwipeLabel;
@property (nonatomic, weak) IBOutlet UILabel *circleStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *triggeredLabel;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSMutableArray *fieldsToClear;

@end

@implementation CMNDisplayViewController
{
    TrackingGestureRecognizer *_trackingRecognizer;
    UITapGestureRecognizer *_tapRecognizer;
    UILongPressGestureRecognizer *_longPressRecognizer;
    UISwipeGestureRecognizer *_swipeRecognizer;
    UIRotationGestureRecognizer *_rotationRecognizer;
    CMNBezelSwipeGestureRecognizer *_bezelSwipeRecognizer;
    PRPCircleGestureRecognizer *_circleRecognizer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self clearFields];
    [self setupGestureRecognizers];
}


#pragma mark - Setup

- (void)setupGestureRecognizers
{
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerFired:)];
    [self.tableView addGestureRecognizer:_tapRecognizer];
    [_tapRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

    _trackingRecognizer = [[TrackingGestureRecognizer alloc] initWithTarget:self action:@selector(trackingRecognizerFired:)];
    [self.tableView addGestureRecognizer:_trackingRecognizer];
    _trackingRecognizer.delegate = self;

    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizerFired:)];
    [self.tableView addGestureRecognizer:_longPressRecognizer];
    [_longPressRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizerFired:)];
    _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:_swipeRecognizer];
    [_swipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

    _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRecognizerFired:)];
    [self.tableView addGestureRecognizer:_rotationRecognizer];
    [_rotationRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

    _circleRecognizer = [[PRPCircleGestureRecognizer alloc] initWithTarget:self action:@selector(circleRecognizerFired:)];
    [self.tableView addGestureRecognizer:_circleRecognizer];
    [_circleRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];

    _bezelSwipeRecognizer = [[CMNBezelSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bezelRecognizerFired:)];
    [self.tableView addGestureRecognizer:_bezelSwipeRecognizer];
    [_bezelSwipeRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer == _trackingRecognizer || otherGestureRecognizer == _trackingRecognizer;
}


#pragma mark - Gesture Recognizer Actions

- (void)trackingRecognizerFired:(TrackingGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self clearFields];
    }

    NSString *stateText = [self nameFromState:recognizer.state];
    CGPoint point = [recognizer locationInView:self.tableView];

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
    
    // So, what happens if you swipe to the left on the right side?
}

- (void)rotationRecognizerFired:(UIRotationGestureRecognizer *)recognizer
{
    NSString *text = [NSString stringWithFormat:@"Rotated! (r: %0.2f, v: %0.2f)",
                      recognizer.rotation, recognizer.velocity];
    [self triggerMessage:text];
}

- (void)bezelRecognizerFired:(CMNBezelSwipeGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Bezel!"];
}

- (void)circleRecognizerFired:(PRPCircleGestureRecognizer *)recognizer
{
    [self triggerMessage:@"Circle!"];
}

- (void)triggerMessage:(NSString *)triggerMessage
{
    _triggeredLabel.text = triggerMessage;
    [self.tableView reloadData];
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
    } else if (recognizer == _bezelSwipeRecognizer) {
        self.bezelSwipeLabel.text = stateName;
    } else if (recognizer == _circleRecognizer) {
        self.circleStateLabel.text = stateName;
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

- (void)clearFields
{
    for (UILabel *field in self.fieldsToClear) {
        field.text = nil;
    }
}

@end
