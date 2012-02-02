#import "SVGView.h"
#import "SVGDocument.h"

@implementation SVGView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		NSString *filename = [[NSBundle mainBundle] pathForResource:@"Beastie" ofType:@"svg"];
		document = [[SVGDocument alloc] initWithContentsOfFile:filename outlinedShapes:YES];
    }
    return self;
}

- (void)dealloc {
	[document release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[document resizeTo:rect.size withPadding:0.05];
	[document drawInContext:context withDebug:NO];
}

@end
