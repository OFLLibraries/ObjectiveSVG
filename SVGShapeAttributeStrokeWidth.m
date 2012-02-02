#import "SVGShapeAttributeStrokeWidth.h"

@implementation SVGShapeAttributeStrokeWidth

+ (CGFloat)parse:(NSString *)strokeWidthValue {
   if(strokeWidthValue == nil)
      return 1.0;

   CGFloat strokeWidth;
   const char *needle = [strokeWidthValue UTF8String];
#if TARGET_OS_IPHONE
   sscanf(needle, "%f", &strokeWidth);
#else
	sscanf(needle, "%lf", &strokeWidth);
#endif
   return strokeWidth;
}

@end
