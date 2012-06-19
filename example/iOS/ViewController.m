#import "ViewController.h"
#import "SVGView.h"
#import "SVGDocument.h"

@implementation ViewController

@synthesize slider;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	SVGDocument *document = ((SVGView *)self.view).document;
	[document resizeTo:self.view.bounds.size withPadding:0.05];
}

- (IBAction)scaleChanged:(id)sender {
	if(slider.value < 0.001)
		return;
	static CGFloat currentDocumentScale = 1.0;
	SVGDocument *document = ((SVGView *)self.view).document;
	CGFloat invertedScaleTimesNewScale = (1.0 / currentDocumentScale) * slider.value;
	[document rescaleTo:invertedScaleTimesNewScale];
	[self.view setNeedsDisplay];
	currentDocumentScale = slider.value;
}

@end
