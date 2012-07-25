
#import <Foundation/Foundation.h>

@interface Vector : NSObject
+ (CGPoint) makeWithX: (float)x Y:(float)y;
+ (CGPoint) makeIdentity;
+ (CGPoint) add: (CGPoint) vec1 to: (CGPoint) vec2;
+ (CGPoint) truncate: (CGPoint) vec to: (float) max;
+ (CGPoint) multiply: (CGPoint) vec by: (float) factor;
+ (float) lengthSquared: (CGPoint) vec;
+ (float) length: (CGPoint) vec;
+ (CGPoint) subtract: (CGPoint) vec from: (CGPoint) vec;
+ (CGPoint) invert: (CGPoint) vec;
@end
