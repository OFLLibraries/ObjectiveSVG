#import "SVGPathCommandQuadraticBezierCurveTo.h"
#import "SVGPathCommandCurveRemembrance.h"

@implementation SVGPathCommandQuadraticBezierCurveTo

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f,%f,%f,%f", &x1, &y1, &x, &y) != 4) {
#else
		if(sscanf([dataWithCommas bytes], "%lf,%lf,%lf,%lf", &x1, &y1, &x, &y) != 4) {
#endif
         [self release];
         self = nil;
      }
      else {
         SVGPathCommandCurveRemembrance *remembrance = [SVGPathCommandCurveRemembrance sharedObject];
         remembrance.startingPoint = CGPointMake(x, y);
         remembrance.controlPoint = CGPointMake(x1, y1);
      }
   }
   return self;   
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   return;
}

- (void)rescaleTo:(CGFloat)scale {
   x1 *= scale;
   y1 *= scale;
   x *= scale;
   y *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      x1 += vector.x;
      y1 += vector.y;
      x += vector.x;
      y += vector.y;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      CGContextAddQuadCurveToPoint(context, x1, y1, x, y);
   else {
      CGPoint cp = CGContextGetPathCurrentPoint(context);
      CGContextAddQuadCurveToPoint(context, x1 + cp.x, y1 + cp.y, x + cp.x, y + cp.y);
   }
}

@end
