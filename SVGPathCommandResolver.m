#import "SVGPathCommandResolver.h"
#import "SVGPathCommandMoveTo.h"
#import "SVGPathCommandLineTo.h"
#import "SVGPathCommandHorizontalLineTo.h"
#import "SVGPathCommandVerticalLineTo.h"
#import "SVGPathCommandCurveTo.h"
#import "SVGPathCommandSmoothCurveTo.h"
#import "SVGPathCommandQuadraticBezierCurveTo.h"
#import "SVGPathCommandSmoothQuadraticBezierCurveTo.h"
#import "SVGPathCommandEllipticalArc.h"
#import "SVGPathCommandClosePath.h"

@implementation SVGPathCommandResolver

+ (id)sharedObject {
   static id instance;
   
   if(!instance)
      instance = [[self alloc] init];
   
   return instance;
}

- (Class)resolveCommandClassByCharacter:(char)character {
   switch(tolower(character)) {
      case 'm':
         return [SVGPathCommandMoveTo class];
      case 'l':
         return [SVGPathCommandLineTo class];
      case 'h':
         return [SVGPathCommandHorizontalLineTo class];
      case 'v':
         return [SVGPathCommandVerticalLineTo class];
      case 'c':
         return [SVGPathCommandCurveTo class];
      case 's':
         return [SVGPathCommandSmoothCurveTo class];
      case 'q':
         return [SVGPathCommandQuadraticBezierCurveTo class];
      case 't':
         return [SVGPathCommandSmoothQuadraticBezierCurveTo class];
      case 'a':
         return [SVGPathCommandEllipticalArc class];
      case 'z':
         return [SVGPathCommandClosePath class];
   }
   return nil;
}

@end
