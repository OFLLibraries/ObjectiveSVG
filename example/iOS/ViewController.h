#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UISlider *slider;

- (IBAction)scaleChanged:(id)sender;

@end
