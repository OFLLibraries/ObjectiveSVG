#import "SVGPathCommandClosePath.h"

@implementation SVGPathCommandClosePath

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   return [super initWithData:data coordinates:aRelativity];
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   return;
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   CGContextClosePath(context);
}

@end
