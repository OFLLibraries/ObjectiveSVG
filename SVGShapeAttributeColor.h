#import "SVGShapeAttribute.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface SVGShapeAttributeColor : SVGShapeAttribute

+ (CGColorRef)parse:(NSString *)colorValue;

@end
