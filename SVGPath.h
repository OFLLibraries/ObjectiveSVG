#import "SVGShape.h"
#import "SVGElement.h"

@interface SVGPath : SVGShape <SVGElement> {
   NSMutableArray *commands;
}

@end
