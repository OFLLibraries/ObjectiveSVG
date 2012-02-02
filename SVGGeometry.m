#import "SVGGeometry.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CoreGraphics.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation SVGGeometry

+ (BOOL)point:(CGPoint)point inPolygon:(CGPoint *)vertices numberOfVertices:(NSUInteger)numberOfVertices {
   NSUInteger i, j = 0;
   BOOL oddNodes = NO;
   
   for(i = 0; i < numberOfVertices; i++) {
      ++j;
      if(j == numberOfVertices)
         j = 0;
      if((vertices[i].y < point.y && vertices[j].y >= point.y) || (vertices[j].y < point.y && vertices[i].y >= point.y)) {
         if(vertices[i].x + (point.y - vertices[i].y) / (vertices[j].y - vertices[i].y) * (vertices[j].x - vertices[i].x) < point.x)
            oddNodes = !oddNodes;
      }
   }
   return oddNodes;
}

@end
