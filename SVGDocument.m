#import "SVGDocument.h"
#import "SVGHeader.h"
#import "SVGShape.h"
#import "SVGShapeOutline.h"
#import "SVGRect.h"
#import "SVGEllipse.h"
#import "SVGPath.h"
#import "SVGGeometry.h"

static inline CGFloat min(CGFloat value1, CGFloat value2) {
   return value1 < value2 ? value1 : value2;
}

static inline CGFloat max(CGFloat value1, CGFloat value2) {
	return value1 > value2 ? value1 : value2;
}

static inline CGFloat clamp(CGFloat value, CGFloat min_value, CGFloat max_value) {
   return min(max_value, max(min_value, value));
}

@interface SVGDocument(Delegate) <NSXMLParserDelegate>

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end

@interface SVGDocument ()

- (BOOL)parse:(NSData *)data;
- (void)addShape:(SVGShape *)shape;

@end

@implementation SVGDocument

@synthesize shapes;

- (id)init {
   if(self = [super init]) {
      header = [SVGHeader alloc];
      shapes = [NSMutableArray new];
      scale = 1.0f;
   }
   return self;
}

- (id)initWithData:(NSData *)data outlinedShapes:(BOOL)isOutlined {
   if((self = [self init])) {
      outlined = isOutlined;
      if(![self parse:data]) {
         [self release];
         return nil;
      }
      if(outlined)
         [shapes sortUsingSelector:@selector(compareShapeOutlineArea:)];
   }
   return self;
}

- (id)initWithContentsOfFile:(NSString *)filePath outlinedShapes:(BOOL)isOutlined {
   NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
   self = [self initWithData:data outlinedShapes:isOutlined];
   [data release];
   return self;
}

- (BOOL)parse:(NSData *)data {
   BOOL retval;
   NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
   [parser setDelegate:self];
   retval = [parser parse];
   [parser release];
   return retval;
}

- (void)addShape:(SVGShape *)shape {
   if(shape != nil) {
      [shapes addObject:shape];
      [shape release];
   }
}

- (void)resizeTo:(CGSize)size withPadding:(CGFloat)padding {
   CGFloat xScale, yScale;
   CGFloat xPad, yPad;
   CGFloat width, height;
	
   xPad = (size.width * clamp(padding, 0.0, 0.5)) / 2;
   yPad = (size.height * clamp(padding, 0.0, 0.5)) / 2;
   xScale = (size.width - 2 * xPad) / header.intrinsicSize->width;
   yScale = (size.height - 2 * yPad) / header.intrinsicSize->height;
   scale = (xScale < yScale) ? xScale : yScale;
   width = scale * header.intrinsicSize->width;
   height = scale * header.intrinsicSize->height;
   translation = CGPointMake((size.width - width) / 2, (size.height - height) / 2);
	
   for(SVGShape *shape in shapes) {
      [shape rescaleTo:scale];
      [shape moveAlongVector:translation];
   }
}

- (void)rescaleTo:(CGFloat)aScale {
   for(SVGShape *shape in shapes)
      [shape rescaleTo:aScale];
}

- (SVGShape *)shapeAtPoint:(CGPoint)point {
   if(!outlined)
      return nil;

   NSMutableArray *suspectedShapes = [NSMutableArray new];
   SVGShape *smallestShape = nil;
	
   for(SVGShape *shape in shapes)
		if(shape.outline.closed && CGRectContainsPoint(shape.outline.boundingRect, point))
				[suspectedShapes addObject:shape];
   [suspectedShapes sortUsingSelector:@selector(compareShapeOutlineArea:)];
	for(SVGShape *suspectedShape in [suspectedShapes reverseObjectEnumerator]) {
		if([SVGGeometry point:point inPolygon:suspectedShape.outline.vertices numberOfVertices:suspectedShape.outline.verticesCount]) {
			smallestShape = suspectedShape;
			break;
		}
	}
	[suspectedShapes release];
	return smallestShape;
}

- (void)revertColors {
   for(SVGShape *shape in shapes)
      [shape revertFillColor];
}

- (void)drawInContext:(CGContextRef)context withDebug:(BOOL)debug {
   for(SVGShape *shape in shapes)
      [shape drawInContext:context withDebug:debug];
}

#if TARGET_OS_IPHONE
- (UIImage *)drawToImageOfSize:(CGSize)size {
#else
- (NSImage *)drawToImageOfSize:(CGSize)size {
#endif
   [self resizeTo:size withPadding:0.05];
   CGColorSpaceRef RGBColorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef context = CGBitmapContextCreate(NULL,
                                                size.width,
                                                size.height,
                                                8,
                                                size.width * 4,
                                                RGBColorSpace,
                                                kCGImageAlphaNoneSkipLast);
   CGColorSpaceRelease(RGBColorSpace);
   CGContextSaveGState(context);
   CGContextAddRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
   CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
   CGContextDrawPath(context, kCGPathEOFill);
   CGContextRestoreGState(context);
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
   [self drawInContext:context withDebug:NO];
	CGContextRestoreGState(context);
   CGImageRef transitionalImage = CGBitmapContextCreateImage(context);
   CGContextRelease(context);
#if TARGET_OS_IPHONE
   UIImage *image = [UIImage imageWithCGImage:transitionalImage];
#else
	NSImage *image = [[NSImage alloc] initWithCGImage:transitionalImage size:NSZeroSize];
#endif
	[self rescaleTo:1/scale];
   return image;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
   if([elementName isEqualToString:@"svg"])
      [header initWithAttributes:attributeDict outlined:outlined];
   else if([elementName isEqualToString:@"rect"])
      [self addShape:[[SVGRect alloc] initWithAttributes:attributeDict outlined:outlined]];
   else if([elementName isEqualToString:@"ellipse"])
      [self addShape:[[SVGEllipse alloc] initWithAttributes:attributeDict outlined:outlined]];
   else if([elementName isEqualToString:@"path"])
      [self addShape:[[SVGPath alloc] initWithAttributes:attributeDict outlined:outlined]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

- (void)dealloc {
   [shapes release];
   [header release];
   [super dealloc];
}

@end
