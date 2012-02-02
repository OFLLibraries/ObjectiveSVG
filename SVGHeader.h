#import "SVGElement.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface SVGHeader : NSObject <SVGElement> {
   NSMutableString *version;
   NSMutableString *identifier;
   CGSize intrinsicSize;
   CGRect viewBox;
}
@property(assign) NSMutableString *version;
@property(assign) NSMutableString *identifier;
@property(readonly) CGSize *intrinsicSize;
@property(readonly) CGRect *viewBox;

@end
