#import <Foundation/Foundation.h>

@class Order;
@class Schedule;

@interface Printer : NSObject

- (NSArray *)print:(Schedule *)scheduleItems order:(Order *)order;

- (void)printError:(id)o order:(id)order;
@end