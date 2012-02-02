@interface SVGPathCommandResolver : NSObject

+ (id)sharedObject;
- (Class)resolveCommandClassByCharacter:(char)character;

@end
