#import "SVGPathCommandHorizontalLineTo.h"

@implementation SVGPathCommandHorizontalLineTo

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f", &x) != 1) {
#else
		if(sscanf([dataWithCommas bytes], "%lf", &x) != 1) {
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
      [collector addVertex:CGPointMake(x, sp.y)];
   else
      [collector addVertex:CGPointMake(sp.x + x, sp.y)];
}

- (void)rescaleTo:(CGFloat)scale {
   x *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      x += vector.x;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   CGPoint cp = CGContextGetPathCurrentPoint(context);
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      CGContextAddLineToPoint(context, x, cp.y);
   else
      CGContextAddLineToPoint(context, x + cp.x, cp.y);
}

@end
