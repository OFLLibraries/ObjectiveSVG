#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface SVGPathCommandCurveRemembrance : NSObject {
   CGPoint startingPoint;
   CGPoint controlPoint;
}
@property(assign, readwrite) CGPoint startingPoint;
@property(assign, readwrite) CGPoint controlPoint; 
@property(assign, readonly) CGPoint reflectionControlPoint;

+ (id)sharedObject;

@end
