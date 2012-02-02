#import "SVGHeader.h"
#if TARGET_OS_IPHONE
#include <CoreGraphics/CoreGraphics.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#include <stdio.h>

@implementation SVGHeader

@synthesize version, identifier;

- (id)init {
   if((self = [super init])) {
      version = [[NSMutableString alloc] init];
      identifier = [[NSMutableString alloc] init];
   }
   return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes outlined:(BOOL)outlined {
   if((self = [self init])) {
      NSString *string;
      const char *characters;
      CGFloat f1, f2, f3, f4;
		
      if((self = [self init])) {
         if((string = [attributes objectForKey:@"version"]))
            [version setString:string];
         if((string = [attributes objectForKey:@"id"]))
            [identifier setString:string];
         
         if((string = [attributes objectForKey:@"width"])) {
            characters = [[string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] bytes];
#if TARGET_OS_IPHONE
            if((sscanf(characters, "%fpx", &f1)) != 1)
#else
				if((sscanf(characters, "%lfpx", &f1)) != 1)
#endif
               return NO; //FIXME
            else
               intrinsicSize.width = f1;
         }
         if((string = [attributes objectForKey:@"height"])) {
            characters = [[string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] bytes];
#if TARGET_OS_IPHONE
            if((sscanf(characters, "%fpx", &f1)) != 1)
#else
				if((sscanf(characters, "%lfpx", &f1)) != 1)
#endif
               return NO; //FIXME
            else
               intrinsicSize.height = f1;
         }
         if((string = [attributes objectForKey:@"viewBox"])) {
            characters = [[string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] bytes];
#if TARGET_OS_IPHONE
            if((sscanf(characters, "%f %f %f %f", &f1, &f2, &f3, &f4)) != 4)
#else
				if((sscanf(characters, "%f %f %f %f", &f1, &f2, &f3, &f4)) != 4)
#endif
               return NO; //FIXME
            else {
               viewBox.origin.x = f1;
               viewBox.origin.y = f2;
               viewBox.size.width = f3;
               viewBox.size.height = f4;
            }
         }
      }
   }
   return self;   
}

- (CGSize *)intrinsicSize {
   return &intrinsicSize;
}

- (CGRect *)viewBox {
   return &viewBox;
}

- (void)dealloc { 
   [identifier release];
   [version release];
   [super dealloc];
}

@end
