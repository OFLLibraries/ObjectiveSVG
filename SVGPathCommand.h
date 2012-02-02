#import "SVGShape.h"
#import "SVGPathOutlineVerticesCollector.h"

enum SVGPathCommandRelativity {
   SVG_PATH_COMMAND_ABSOLUTE,
   SVG_PATH_COMMAND_RELATIVE
};

@protocol SVGPathCommandProtocol <NSObject>

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)relativity;
- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector;

@end

@interface SVGPathCommand : SVGShape <SVGPathCommandProtocol> {
   NSMutableData *dataWithCommas;
   enum SVGPathCommandRelativity relativity;
}

- (void)moveAlongVector:(CGPoint)vector;

@end
