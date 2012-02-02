#import "SVGShapeAttribute.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface SVGShapeAttributeStrokeWidth : SVGShapeAttribute

+ (CGFloat)parse:(NSString *)strokeWidthValue;

@end
