#import "SVGPathCommandAccumulator.h"
#import "SVGPathCommandCurveTo.h"
#import "SVGPathCommandQuadraticBezierCurveTo.h"
#include <ctype.h>

@implementation SVGPathCommandAccumulator

- (id)init {
   if((self = [super init]))
      data = [NSMutableData new];
   return self;
}

- (void)bootstrapCommand:(Class)commandClass coordinates:(BOOL)aRelativity {
   command = nil;
   [data setLength:0];
   relativity = aRelativity;
   command = commandClass;
}

- (void)accumulateByte:(char)byte {
   if(!isspace(byte))
      [data appendBytes:&byte length:sizeof(char)];
}

- (id)assemble {
   if(data.length != 0)
      return [[command alloc] initWithData:data coordinates:relativity];
   else
      return nil;
}

- (void)dealloc {
   [data release];
   [super dealloc];
}

@end
