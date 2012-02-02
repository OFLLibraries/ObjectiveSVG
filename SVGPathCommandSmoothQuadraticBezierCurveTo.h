#import "SVGPathCommand.h"

@interface SVGPathCommandSmoothQuadraticBezierCurveTo : SVGPathCommand <SVGPathCommandProtocol> {
@public
   CGFloat x1, y1;
   CGFloat x, y;
}

@end
