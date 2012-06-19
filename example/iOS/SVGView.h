#import <UIKit/UIKit.h>

@class SVGDocument;

@interface SVGView : UIView {
	SVGDocument *document;
}
@property(assign) SVGDocument *document;

@end
