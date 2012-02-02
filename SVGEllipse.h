#import "SVGShape.h"
#import "SVGElement.h"

@interface SVGEllipse : SVGShape <SVGElement> {
   CGFloat cx;
   CGFloat cy;
   CGFloat rx;
   CGFloat ry;
}
@property(readonly) CGFloat cx;
@property(readonly) CGFloat cy;
@property(readonly) CGFloat rx;
@property(readonly) CGFloat ry;

@end
