#import "SVGPathCommandCurveTo.h"
#import "SVGPathCommandCurveRemembrance.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CoreGraphics.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation SVGPathCommandCurveTo

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super initWithData:data coordinates:aRelativity])) {
#if TARGET_OS_IPHONE
      if(sscanf([dataWithCommas bytes], "%f,%f,%f,%f,%f,%f", &x1, &y1, &x2, &y2, &x, &y) != 6) {
#else
		if(sscanf([dataWithCommas bytes], "%lf,%lf,%lf,%lf,%lf,%lf", &x1, &y1, &x2, &y2, &x, &y) != 6) {
#endif
         [self release];
         self = nil;
      }
      else {
         SVGPathCommandCurveRemembrance *remembrance = [SVGPathCommandCurveRemembrance sharedObject];
         remembrance.startingPoint = CGPointMake(x, y);
         remembrance.controlPoint = CGPointMake(x2, y2);
      }
   }
   return self;   
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   if(!collector)
      return;
   const size_t NUMBER_OF_SAMPLES = 5;
   CGPoint v[NUMBER_OF_SAMPLES];
   NSValue *values[NUMBER_OF_SAMPLES];
   float t = 0.0f;
   CGPoint sp = [collector tail];
   
   for(size_t i = 0; i < NUMBER_OF_SAMPLES; i++) {
      t += 1.0f / NUMBER_OF_SAMPLES;
      if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
         v[i].x = sp.x * powf(1.f - t, 3) + 3 * x1 * t * powf(1.f - t, 2) + 3 * x2 * powf(t, 2) * (1.f - t) + x * powf(t, 3);
         v[i].y = sp.y * powf(1.f - t, 3) + 3 * y1 * t * powf(1.f - t, 2) + 3 * y2 * powf(t, 2) * (1.f - t) + y * powf(t, 3);
      }
      else {
         v[i].x = sp.x * powf(1.f - t, 3) + 3 * (sp.x + x1) * t * powf(1.f - t, 2) + 3 * (sp.x + x2) * powf(t, 2) * (1.f - t) + (sp.x + x) * powf(t, 3);
         v[i].y = sp.y * powf(1.f - t, 3) + 3 * (sp.y + y1) * t * powf(1.f - t, 2) + 3 * (sp.y + y2) * powf(t, 2) * (1.f - t) + (sp.y + y) * powf(t, 3);
      }
#if TARGET_OS_IPHONE
      values[i] = [NSValue valueWithCGPoint:v[i]];
#else
		values[i] = [NSValue valueWithPoint:v[i]];
#endif
   }
   [collector addVerticesFromArray:[NSArray arrayWithObjects:values count:NUMBER_OF_SAMPLES]];
}

- (void)rescaleTo:(CGFloat)scale {
   x1 *= scale;
   y1 *= scale;
   x2 *= scale;
   y2 *= scale;
   x *= scale;
   y *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE) {
      x1 += vector.x;
      y1 += vector.y;
      x2 += vector.x;
      y2 += vector.y;
      x += vector.x;
      y += vector.y;
   }
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   if(relativity == SVG_PATH_COMMAND_ABSOLUTE)
      CGContextAddCurveToPoint(context, x1, y1, x2, y2, x, y);
   else {
      CGPoint cp = CGContextGetPathCurrentPoint(context);
      CGContextAddCurveToPoint(context, x1 + cp.x, y1 + cp.y, x2 + cp.x, y2 + cp.y, x + cp.x, y + cp.y);
   }
}

@end
