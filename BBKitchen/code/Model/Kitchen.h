#import <Foundation/Foundation.h>

@class Order;
@class ScheduleItem;
@class FryerFactory;
@class Scheduler;
@class Schedule;


@interface Kitchen : NSObject

- (instancetype)initWithScheduler:(Scheduler *)scheduler;
- (NSArray *)placeOrders:(NSArray *)orders;
- (Schedule *)placeOrder:(Order *)order error:(NSError**)error;

@end