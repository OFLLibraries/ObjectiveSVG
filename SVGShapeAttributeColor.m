#import "SVGShapeAttributeColor.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation SVGShapeAttributeColor

+ (CGColorRef)parse:(NSString *)colorValue {
   if(colorValue == nil)
      return nil;
   if([colorValue isEqual:@"none"])
      return nil;
	
   CGColorRef color;
   CGColorSpaceRef rgb;
   const char *needle = [colorValue UTF8String];
   unsigned r, g, b;
	
   if(strncmp(needle, "#", 1) == 0) {
      char rbuf[2 + 1], gbuf[2 + 1], bbuf[2 + 1];
      size_t rgb_len = strlen(needle + 1);
      if(rgb_len == 3) {
         strncpy(rbuf, needle + 1, 1);
         strncpy(rbuf + 1, needle + 1, 1);
         rbuf[2] = '\0';
         strncpy(gbuf, needle + 2, 1);
         strncpy(gbuf + 1, needle + 2, 1);
         gbuf[2] = '\0';
         strncpy(bbuf, needle + 3, 1);
         strncpy(bbuf + 1, needle + 3, 1);
         bbuf[2] = '\0';
      }
      else if(rgb_len == 6) {
         strncpy(rbuf, needle + 1, 2);
         rbuf[2] = '\0';
         strncpy(gbuf, needle + 3, 2);
         gbuf[2] = '\0';
         strncpy(bbuf, needle + 5, 2);
         bbuf[2] = '\0';
      }
      else
         return nil;

      sscanf(rbuf, "%x", &r);
      sscanf(gbuf, "%x", &g);
      sscanf(bbuf, "%x", &b);
      rgb = CGColorSpaceCreateDeviceRGB();
      color = CGColorCreate(rgb, (CGFloat[]){ (CGFloat)r / 255.0, (CGFloat)g / 255.0, (CGFloat)b / 255.0, 1.0 });
      CGColorSpaceRelease(rgb);
      return color;
   }
   else if(strncmp(needle, "rgb", 3) == 0) {
      NSLog(@"SVGShapeAttributeColor: rgb()");
   }
   else {
      NSLog(@"SVGShapeAttributeColor: 'color keyword'");
   }
   return nil;
}

@end
