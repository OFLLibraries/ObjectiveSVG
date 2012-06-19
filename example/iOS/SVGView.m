#import "SVGView.h"
#import "SVGDocument.h"

@implementation SVGView

@synthesize document;

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
	[document drawInContext:context withDebug:NO];
}

@end
