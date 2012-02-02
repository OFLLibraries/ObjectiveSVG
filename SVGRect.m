#import "SVGRect.h"

@implementation SVGRect

@synthesize x, y, rx, ry, width, height;

- (id)initWithAttributes:(NSDictionary *)attributes outlined:(BOOL)outlined {
   if(self = [super initWithAttributes:attributes outlined:outlined]) {
      x = [[attributes objectForKey:@"x"] floatValue];
      y = [[attributes objectForKey:@"y"] floatValue];
      width = [[attributes objectForKey:@"width"] floatValue];
      height = [[attributes objectForKey:@"height"] floatValue];
   }
   return self;
}

- (void)rescaleTo:(CGFloat)scale {
   x *= scale;
   y *= scale;
   width *= scale;
   height *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   x += vector.x;
   y += vector.y;
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   CGContextSaveGState(context);
   CGRect rect = CGRectMake(x, y, width, height);
   CGContextSetLineWidth(context, round(strokeWidth));
   if(strokeColor)
		CGContextSetStrokeColorWithColor(context, strokeColor);
   if(fillColor)
		CGContextSetFillColorWithColor(context, fillColor);
   CGContextAddRect(context, rect);
   if(fillColor)
      CGContextDrawPath(context, kCGPathEOFillStroke);
   else
      CGContextDrawPath(context, kCGPathStroke);
   CGContextRestoreGState(context);
}

@end
