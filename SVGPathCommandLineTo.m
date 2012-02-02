#import "SVGPathCommandLineTo.h"

@implementation SVGPathCommandLineTo

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f,%f", &x, &y) != 2) {
#else
		if(sscanf([dataWithCommas bytes], "%lf,%lf", &x, &y) != 2) {
#endif
         [self release];
         self = nil;
      }
   }
   return self;   
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   if(!collector)
      return;
   CGPoint sp = [collector tail];
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      [collector addVertex:CGPointMake(x, y)];
   else
      [collector addVertex:CGPointMake(sp.x + x, sp.y + y)];
}

- (void)rescaleTo:(CGFloat)scale {
   x *= scale;
   y *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      x += vector.x;
      y += vector.y;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      CGContextAddLineToPoint(context, x, y);
   else {
      CGPoint cp = CGContextGetPathCurrentPoint(context);
      CGContextAddLineToPoint(context, x + cp.x, y + cp.y);
   }
}

@end
