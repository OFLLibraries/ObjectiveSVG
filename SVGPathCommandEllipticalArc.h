#import "SVGPathCommand.h"

@interface SVGPathCommandEllipticalArc : SVGPathCommand <SVGPathCommandProtocol> {
@public
   CGFloat rx, ry;
   CGFloat xAxisRotation;
   CGFloat largeArcFlag;
   CGFloat sweepFlag;
   CGFloat x, y;
}

@end
