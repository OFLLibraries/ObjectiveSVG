#import "SVGPathCommand.h"

@implementation SVGPathCommand

- (id)initWithData:(NSData *)data coordinates:(enum SVGPathCommandRelativity)aRelativity {
   if((self = [super init])) {
      if(data == nil)
         return self;
      dataWithCommas = [NSMutableData new];
      char byte;
      const char comma = ',';
      const char zero = '\0';
      NSInteger length = [data length], i;
      for(i = 0; i < length; i++) {
         byte = *((char *)[data bytes] + i * sizeof(char));
         if(byte == '-' && i != 0)
            [dataWithCommas appendBytes:&comma length:sizeof(char)];
         [dataWithCommas appendBytes:&byte length:sizeof(char)];
      }
      [dataWithCommas appendBytes:&zero length:sizeof(char)];
      [dataWithCommas setLength:[dataWithCommas length] - 1];
      relativity = aRelativity;
   }
   return self;
}

- (void)appendOutlineVerticesToCollector:(SVGPathOutlineVerticesCollector *)collector {
   return;
}

- (void)moveAlongVector:(CGPoint)vector {
   return;
}

- (void)dealloc {
   [dataWithCommas release];
   [super dealloc];
}

@end
