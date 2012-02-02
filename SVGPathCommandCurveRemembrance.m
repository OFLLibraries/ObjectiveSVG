#import "SVGPathCommandCurveRemembrance.h"

@implementation SVGPathCommandCurveRemembrance

@synthesize startingPoint;
@synthesize controlPoint;

+ (id)sharedObject {
   static id instance;
   
   if(!instance)
      instance = [[self alloc] init];
   
   return instance;
}

- (CGPoint)reflectionControlPoint {
   CGPoint reflectionControlPoint;
   reflectionControlPoint.x = 2 * startingPoint.x - controlPoint.x;
   reflectionControlPoint.y = 2 * startingPoint.y - controlPoint.y;
   return reflectionControlPoint;
}

@end
