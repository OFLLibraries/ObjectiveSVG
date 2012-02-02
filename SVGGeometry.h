#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface SVGGeometry : NSObject

+ (BOOL)point:(CGPoint)point inPolygon:(CGPoint *)vertices numberOfVertices:(NSUInteger)numberOfVertices;

@end
