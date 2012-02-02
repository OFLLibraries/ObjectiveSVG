#import "SVGPathCommand.h"

@interface SVGPathCommandAccumulator : NSObject {
   Class command;
   enum SVGPathCommandRelativity relativity;
   NSMutableData *data;
   CGPoint lastControlPoint;
}

- (void)bootstrapCommand:(Class)commandClass coordinates:(BOOL)aRelativity;
- (void)accumulateByte:(char)byte;
- (id)assemble;

@end
