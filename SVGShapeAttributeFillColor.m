#import "SVGShapeAttributeFillColor.h"

@implementation SVGShapeAttributeFillColor

+ (CGColorRef)parse:(NSString *)colorValue {
   CGColorRef color = [super parse:colorValue];
   if(color) {
      const CGFloat *components = CGColorGetComponents(color);
      if(components[0] == 1.0 && components[1] == 0.0 && components[2] == 1.0) {
         CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
         color = CGColorCreate(rgb, (CGFloat[]){ 0.0, 0.0, 0.0, 0.0 });
         CGColorSpaceRelease(rgb);
         return color;
      }
   }
   if(color == nil && ![colorValue isEqual:@"none"]) {
      CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
      color = CGColorCreate(rgb, (CGFloat[]){ 0.0, 0.0, 0.0, 1.0 });
      CGColorSpaceRelease(rgb);
   }
   return color;
}

@end
