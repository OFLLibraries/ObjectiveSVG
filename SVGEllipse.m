#import "SVGEllipse.h"

@implementation SVGEllipse

@synthesize cx, cy, rx, ry;

- (id)initWithAttributes:(NSDictionary *)attributes outlined:(BOOL)outlined {
   if(self = [super initWithAttributes:attributes outlined:outlined]) {
      cx = [[attributes objectForKey:@"cx"] floatValue];
      cy = [[attributes objectForKey:@"cy"] floatValue];
      rx = [[attributes objectForKey:@"rx"] floatValue];
      ry = [[attributes objectForKey:@"ry"] floatValue];
   }
   return self;
}

- (void)rescaleTo:(CGFloat)scale {
   cx *= scale;
   cy *= scale;
   rx *= scale;
   ry *= scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   cx += vector.x;
   cy += vector.y;
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   CGRect rect = CGRectMake(cx - rx, cy - ry, rx * 2, ry * 2);
   CGContextStrokeEllipseInRect(context, rect);
}

@end
