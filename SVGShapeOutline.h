#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

extern size_t const DASH_LENGHTS_COUNT;

@interface SVGShapeOutline : NSObject {
   CGPoint *vertices;
   NSUInteger verticesCount;
   CGRect boundingRect;
   CGFloat *dashLengths;
   size_t dashLengthsCount;
   CGFloat area;
}
@property(assign) CGPoint *vertices;
@property NSUInteger verticesCount;
@property(assign) CGRect boundingRect;
@property(assign) CGFloat *dashLengths;
@property(assign) size_t dashLengthsCount;
@property(assign) CGFloat area;
@property(assign, readonly) BOOL closed;

- (id)initWithVertexArray:(NSArray *)vertexArray;
- (void)rescaleTo:(CGFloat)scale;
- (void)moveAlongVector:(CGPoint)vector;

@end
