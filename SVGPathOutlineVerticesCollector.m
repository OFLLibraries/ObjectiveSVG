#import "SVGPathOutlineVerticesCollector.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#include <CoreGraphics/CGBase.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation SVGPathOutlineVerticesCollector

@synthesize vertices;

- (id)init {
   if(self = [super init])
      vertices = [NSMutableArray new];
   return self;
}

- (void)addVertex:(CGPoint)vertex {
#if TARGET_OS_IPHONE
   [vertices addObject:[NSValue valueWithCGPoint:vertex]];
#else
	[vertices addObject:[NSValue valueWithPoint:vertex]];
#endif
}

- (void)addVerticesFromArray:(NSArray *)vertexArray {
   [vertices addObjectsFromArray:vertexArray];
}

- (CGPoint)head {
#if TARGET_OS_IPHONE
   return [[vertices objectAtIndex:0] CGPointValue];
#else
	return [[vertices objectAtIndex:0] pointValue];
#endif
}

- (CGPoint)tail {
#if TARGET_OS_IPHONE
   return [[vertices lastObject] CGPointValue];
#else
	return [[vertices lastObject] pointValue];
#endif
}

- (void)dealloc {
   [vertices release];
   [super dealloc];
}

@end
