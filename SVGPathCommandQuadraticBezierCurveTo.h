#import "SVGPathCommand.h"

@interface SVGPathCommandQuadraticBezierCurveTo : SVGPathCommand <SVGPathCommandProtocol> {
@public
   CGFloat x1, y1;
   CGFloat x, y;
}

@end
