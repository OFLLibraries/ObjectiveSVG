#import "SVGPath.h"
#import "SVGPathCommandAccumulator.h"
#import "SVGPathOutlineVerticesCollector.h"
#import "SVGPathCommand.h"
#import "SVGPathCommandResolver.h"
#import "SVGShapeOutline.h"

@interface SVGPath ()

- (void)addCommand:(SVGPathCommand *)command withCollector:(SVGPathOutlineVerticesCollector *)collector;

@end

@implementation SVGPath

- (id)init {
   if(self = [super init])
      commands = [NSMutableArray new];
   return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes outlined:(BOOL)outlined {
   if(self = [super initWithAttributes:attributes outlined:outlined]) {
      SVGPathCommandAccumulator *accumulator = [SVGPathCommandAccumulator new];
      SVGPathOutlineVerticesCollector *collector = (outlined) ? [SVGPathOutlineVerticesCollector new] : nil;
      const char *needle = [[attributes objectForKey:@"d"] UTF8String];
      SVGPathCommandResolver *resolver = [SVGPathCommandResolver sharedObject];
      Class class;
		
      while(*needle) {
         class = [resolver resolveCommandClassByCharacter:*needle];
         if(class == nil)
            [accumulator accumulateByte:*needle];
         else {
            [self addCommand:[accumulator assemble] withCollector:collector];
            [accumulator bootstrapCommand:class coordinates:isupper(*needle) ? NO : YES];
         }
         ++needle;
      }
      [self addCommand:[accumulator assemble] withCollector:collector];
		
      if(outlined) {
         outline = [[SVGShapeOutline alloc] initWithVertexArray:collector.vertices];
         [collector release];
      }
      [accumulator release];
   }
   return self;
}

- (void)addCommand:(SVGPathCommand *)command withCollector:(SVGPathOutlineVerticesCollector *)collector {
   if(command != nil) {
      [commands addObject:command];
      if(collector)
         [command appendOutlineVerticesToCollector: collector];
      [command release];
   }
}

- (void)rescaleTo:(CGFloat)scale {
   [super rescaleTo:scale];
	for(SVGPathCommand *command in commands)
      [command rescaleTo:scale];
}

- (void)moveAlongVector:(CGPoint)vector {
   [super moveAlongVector:vector];
	for(SVGPathCommand *command in commands)
      [command moveAlongVector:vector];
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   if(debug) {
      if(outline.closed && !fixedFillColor) {
         CGContextSaveGState(context);
         CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
         CGContextSetLineWidth(context, 1.0);
         CGContextSetRGBFillColor(context, 0.8f, 0.8f, 0.8f, 1.0f);
         CGContextAddLines(context, outline.vertices, outline.verticesCount);
         CGContextDrawPath(context, kCGPathEOFillStroke);
         CGContextRestoreGState(context);
         CGContextSaveGState(context);
         CGContextSetRGBStrokeColor(context, 1.0f, 0.0f, 0.0f, 0.75f);
         CGContextSetLineWidth(context, 1.0);
         CGContextSetLineDash(context, 0.0f, outline.dashLengths, outline.dashLengthsCount);
         CGContextAddRect(context, outline.boundingRect);
         CGContextDrawPath(context, kCGPathStroke);
         CGContextRestoreGState(context);
      }
   }
   else {
      CGContextSaveGState(context);
      CGContextSetAllowsAntialiasing(context, YES);
      CGContextSetShouldAntialias(context, YES);
      CGContextSetBlendMode(context, kCGBlendModeNormal);
      CGContextSetLineWidth(context, round(strokeWidth));
      for(SVGPathCommand *command in commands)
         [command drawInContext:context withDebug:debug];
      if(fillColor) {
			CGContextSetFillColorWithColor(context, fillColor);
         CGContextDrawPath(context, kCGPathEOFillStroke);
		}
      else
         CGContextDrawPath(context, kCGPathStroke);
      CGContextRestoreGState(context);
   }
}

- (void)dealloc {
   [commands release];
   [super dealloc];
}

@end
