#import <UIKit/UIKit.h>

@interface CMNDisplayViewController : UITableViewController
<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *trackingStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tapStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *longPressStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *swipeStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *rotationStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *rotationDataLabel;
@property (nonatomic, weak) IBOutlet UILabel *customStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *triggeredLabel;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSMutableArray *fieldsToClear;

@end
