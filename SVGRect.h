#import "SVGShape.h"
#import "SVGElement.h"

@interface SVGRect : SVGShape <SVGElement> {
   CGFloat x;
   CGFloat y;
   CGFloat rx;
   CGFloat ry;
   CGFloat width;
   CGFloat height;
}
@property(readonly) CGFloat x;
@property(readonly) CGFloat y;
@property(readonly) CGFloat rx;
@property(readonly) CGFloat ry;
@property(readonly) CGFloat width;
@property(readonly) CGFloat height;

@end
