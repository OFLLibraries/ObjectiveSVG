#import "SVGPathCommand.h"

@interface SVGPathCommandSmoothCurveTo : SVGPathCommand <SVGPathCommandProtocol> {
@public
   CGFloat x1, y1;
   CGFloat x2, y2;
   CGFloat x, y;
}

@end
