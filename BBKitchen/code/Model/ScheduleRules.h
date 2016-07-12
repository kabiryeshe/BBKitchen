#import <Foundation/Foundation.h>

@class Schedule;
@class Order;

@interface ScheduleRules : NSObject
+ (bool)validate:(Schedule *)schedule forOrder:(Order *)order;

@end
