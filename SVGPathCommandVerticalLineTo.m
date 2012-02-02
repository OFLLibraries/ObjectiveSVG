#import "SVGPathCommandVerticalLineTo.h"

@implementation SVGPathCommandVerticalLineTo

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f", &y) != 1) {
#else
		if(sscanf([dataWithCommas bytes], "%lf", &y) != 1) {
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
      [collector addVertex:CGPointMake(sp.x, y)];
   else
      [collector addVertex:CGPointMake(sp.x, sp.y + y)];
}

- (void)rescaleTo:(CGFloat)scale {
   y *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      y += vector.y;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   CGPoint cp = CGContextGetPathCurrentPoint(context);
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      CGContextAddLineToPoint(context, cp.x, y);
   else
      CGContextAddLineToPoint(context, cp.x, cp.y + y);
}

@end
