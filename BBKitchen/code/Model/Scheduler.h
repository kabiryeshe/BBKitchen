#import <Foundation/Foundation.h>

@class Schedule, Order, FryerFactory;
@class Clock;


@interface Scheduler : NSObject

- (instancetype)initWithFryerFactory:(FryerFactory *)fryerFactory time:(NSDate *)time;

- (Schedule *)scheduleOrder:(Order *)order error:(NSError **)outError;

@end