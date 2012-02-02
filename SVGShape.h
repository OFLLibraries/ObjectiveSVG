#import "SVGElement.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@class SVGShapeOutline;

enum SVGFillRule {
   SVG_FILL_RULE_UNDEFINED = 0,
   SVG_FILL_RULE_NONZERO,
   SVG_FILL_RULE_EVENODD,
   SVG_FILL_RULE_INHERIT
};

enum SVGLinecap {
   SVG_LINECAP_UNDEFINED = 0,
   SVG_LINECAP_BUTT,
   SVG_LINECAP_ROUND,
   SVG_LINECAP_SQUARE,
   SVG_LINECAP_INHERIT
};

enum SVGLinejoin {
   SVG_LINEJOIN_UNDEFINED = 0,
   SVG_LINEJOIN_MITER,
   SVG_LINEJOIN_ROUND,
   SVG_LINEJOIN_BEVEL,
   SVG_LINEJOIN_INHERIT
};

@interface SVGShape : NSObject <SVGElement> {
   BOOL customFillColor;
   BOOL fixedFillColor;
   CGColorRef fillColor;
   CGFloat fillOpacity;
   enum SVGFillRule fillRule;
   CGColorRef strokeColor;
   CGFloat strokeWidth;
   CGFloat strokeOpacity;
   NSArray *strokeDasharray;
   CGFloat strokeDashoffset;
   enum SVGLinecap strokeLinecap;
   enum SVGLinejoin strokeLinejoin;
   CGFloat strokeMiterlimit;
   SVGShapeOutline *outline;
}
@property(assign) SVGShapeOutline *outline;
@property(readonly) BOOL customColor;
@property(readonly) BOOL fixedFillColor;

- (void)rescaleTo:(CGFloat)scale;
- (void)moveAlongVector:(CGPoint)vector;
- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug;
#if TARGET_OS_IPHONE
- (void)fillWithColor:(UIColor *)color;
#else
- (void)fillWithColor:(NSColor *)color;
#endif
- (void)revertFillColor;
- (NSComparisonResult)compareShapeOutlineArea:(SVGShape *)otherShape;

@end
