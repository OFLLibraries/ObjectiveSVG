#import "SVGShapeOutline.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

size_t const DASH_LENGHTS_COUNT = 2;

@implementation SVGShapeOutline

@synthesize vertices;
@synthesize verticesCount;
@synthesize boundingRect;
@synthesize dashLengths;
@synthesize dashLengthsCount;
@synthesize area;

- (id)init {
   if(self = [super init]) {
      dashLengths = calloc(DASH_LENGHTS_COUNT, sizeof(CGFloat));
      dashLengthsCount = DASH_LENGHTS_COUNT;
   }
   return self;
}

- (id)initWithVertexArray:(NSArray *)vertexArray {
   if((self = [self init]) && vertexArray != nil && vertexArray.count > 0) {
      CGFloat minx = FLT_MAX;
      CGFloat maxx = -FLT_MAX;
      CGFloat miny = FLT_MAX;
      CGFloat maxy = -FLT_MAX;
      verticesCount = vertexArray.count;
      vertices = malloc(verticesCount * sizeof(CGPoint));
      NSUInteger i = 0;
      for(NSValue *value in vertexArray) {
#if TARGET_OS_IPHONE
         vertices[i] = [value CGPointValue];
#else
			vertices[i] = [value pointValue];
#endif
         if(vertices[i].x < minx)
            minx = vertices[i].x;
         if(vertices[i].x > maxx)
            maxx = vertices[i].x;
         if(vertices[i].y < miny)
            miny = vertices[i].y;
         if(vertices[i].y > maxy)
            maxy = vertices[i].y;
         ++i;
      }
      boundingRect.origin.x = minx;
      boundingRect.origin.y = miny;
      boundingRect.size.width = maxx - minx;
      boundingRect.size.height = maxy - miny;
		
      area = boundingRect.size.width * boundingRect.size.height;
      
      CGFloat avarageLength = (boundingRect.size.width + boundingRect.size.height) / 2;
      for(size_t i = 0; i < dashLengthsCount; i++)
         dashLengths[i] = avarageLength / 10;
   }
   return self;
}

- (void)rescaleTo:(CGFloat)scale {
   for(NSUInteger i = 0; i < verticesCount; i++) {
      vertices[i].x *= scale;
      vertices[i].y *= scale;
   }
   boundingRect.origin.x *= scale;
   boundingRect.origin.y *= scale;
   boundingRect.size.width *= scale;
   boundingRect.size.height *= scale;
   area *=scale;
}

- (void)moveAlongVector:(CGPoint)vector {
   for(NSUInteger i = 0; i < verticesCount; i++) {
      vertices[i].x += vector.x;
      vertices[i].y += vector.y;
   }
   boundingRect.origin.x += vector.x;
   boundingRect.origin.y += vector.y;   
}

- (BOOL)closed {
   if(verticesCount < 3)
      return NO;
   static const CGFloat eps = 0.001f;
   CGPoint head = vertices[0];
   CGPoint tail = vertices[verticesCount - 1];
   return fabsf(head.x - tail.x) < eps && fabsf(head.y - tail.y) < eps ? YES : NO;
}

- (void)dealloc {
   if(dashLengths)
      free(dashLengths);
   if(vertices != nil)
      free(vertices);
   [super dealloc];
}

@end
