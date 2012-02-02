#import "SVGShape.h"
#import "SVGShapeOutline.h"
#import "SVGShapeAttributeFillColor.h"
#import "SVGShapeAttributeStrokeWidth.h"

@implementation SVGShape

@synthesize outline;
@synthesize customColor;
@synthesize fixedFillColor;

- (id)initWithAttributes:(NSDictionary *)attributes outlined:(BOOL)outlined {
   if((self = [self init])) {
      if((fillColor = [SVGShapeAttributeFillColor parse:[attributes objectForKey:@"fill"]]) != nil)
         fixedFillColor = YES;
      else {
         CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
         fillColor = CGColorCreate(rgb, (CGFloat[]){ 1.0f, 1.0f, 1.0f, 1.0f });
         CGColorSpaceRelease(rgb);
      }
      strokeColor = [SVGShapeAttributeColor parse:[attributes objectForKey:@"stroke"]];
      strokeWidth = [SVGShapeAttributeStrokeWidth parse:[attributes objectForKey:@"stroke-width"]] / 2.0;
   }
   return self;
}

- (void)rescaleTo:(CGFloat)scale {
   strokeWidth *= scale;
   [outline rescaleTo:scale];
}

- (void)moveAlongVector:(CGPoint)vector {
   [outline moveAlongVector:vector];
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   return;
}

#if TARGET_OS_IPHONE
- (void)fillWithColor:(UIColor *)color {
#else
- (void)fillWithColor:(NSColor *)color {
#endif
	if(color != nil && !fixedFillColor) {
#if TARGET_OS_IPHONE
		CGColorRef CGColor = color.CGColor;
#else
		CGFloat components[4];
		[color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
		CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		CGColorRef CGColor = CGColorCreate(colorSpace, components);
		CGColorSpaceRelease(colorSpace);
#endif
		if(fillColor != nil)
			CGColorRelease(fillColor);
		CGColorRetain(CGColor);
		fillColor = CGColor;
		customColor = YES;
	}
}

- (void)revertFillColor {
	if(customColor && fillColor != nil) {
		CGColorRelease(fillColor);
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		fillColor = CGColorCreate(rgb, (CGFloat[]){ 1.0f, 1.0f, 1.0f, 1.0f });
		CGColorSpaceRelease(rgb);
	}
}

- (NSComparisonResult)compareShapeOutlineArea:(SVGShape *)otherShape {
	static CGFloat thisShapeArea, otherShapeArea;
	
	if(outline == nil || outline.area <= 0.0f)
		thisShapeArea = 0.0f;
	else
		thisShapeArea = outline.area;
	
	if(otherShape == nil || otherShape.outline == nil || otherShape.outline.area <= 0.0f)
		otherShapeArea = 0.0f;
	else
		otherShapeArea = otherShape.outline.area;
	
	if(thisShapeArea < otherShapeArea)
		return NSOrderedDescending;
	else if (thisShapeArea > otherShapeArea)
		return NSOrderedAscending;
	else 
		return NSOrderedSame;
}

- (void)dealloc {
	if(outline != nil)
		[outline release];
	if(fillColor != nil)
		CGColorRelease(fillColor);
	if(strokeColor != nil)
		CGColorRelease(strokeColor);
	[super dealloc];
}

@end
