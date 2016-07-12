#import <Foundation/Foundation.h>

@class Order;

@interface Parser : NSObject
- (NSArray *)parseInput:(NSArray *)input;

- (Order *)parseOrder:(NSString *)string;
@end