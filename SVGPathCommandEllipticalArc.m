#import "SVGPathCommandEllipticalArc.h"

@implementation SVGPathCommandEllipticalArc

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f,%f,%f,%f,%f,%f,%f", &rx, &ry, &xAxisRotation, &largeArcFlag, &sweepFlag, &x, &y) != 7) {
#else
		if(sscanf([dataWithCommas bytes], "%lf,%lf,%lf,%lf,%lf,%lf,%lf", &rx, &ry, &xAxisRotation, &largeArcFlag, &sweepFlag, &x, &y) != 7) {
#endif
         [self release];
         self = nil;
      }
   }
   return self;   
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   return;
}

- (void)rescaleTo:(CGFloat)scale {
   rx *= scale;
   ry *= scale;
   x *= scale;
   y *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      rx += vector.x;
      ry += vector.y;
      x += vector.x;
      y += vector.y;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   NSLog(@"SVGPathCommandEllipticalArc");
}

@end
