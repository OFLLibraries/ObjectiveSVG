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

- (void)drawRect:(NSRect)dirtyRect {
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
	CGContextTranslateCTM(context, 0.0, dirtyRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	[document resizeTo:dirtyRect.size withPadding:0.05];
	[document drawInContext:context withDebug:NO];
}

@end
