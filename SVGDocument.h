#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@class SVGHeader;
@class SVGShape;

@interface SVGDocument : NSObject {
   SVGHeader *header;
   NSMutableArray *shapes;
   CGFloat scale;
   CGPoint translation;
   BOOL outlined;
}
@property(assign) NSMutableArray *shapes;

- (id)initWithData:(NSData *)data outlinedShapes:(BOOL)outlined;
- (id)initWithContentsOfFile:(NSString *)filePath outlinedShapes:(BOOL)outlined;
- (void)resizeTo:(CGSize)size withPadding:(CGFloat)padding;
- (void)rescaleTo:(CGFloat)scale;
- (SVGShape *)shapeAtPoint:(CGPoint)point;
- (void)revertColors;
- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug;
#if TARGET_OS_IPHONE
- (UIImage *)drawToImageOfSize:(CGSize)size;
#else
- (NSImage *)drawToImageOfSize:(CGSize)size;
#endif

@end
