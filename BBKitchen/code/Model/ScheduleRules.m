#import "ScheduleRules.h"
#import "ScheduleItem.h"
#import "Schedule.h"
#import "Order.h"


@implementation ScheduleRules

+ (bool)validateWaitTime:(Schedule *)schedule {
    const NSTimeInterval waitTime = 120;

    ScheduleItem *firstScheduleItem = schedule.scheduleItems.firstObject;

    return [[schedule endTime] timeIntervalSinceDate:firstScheduleItem.endTime] <= waitTime;
}

+ (bool)validateOrderTime:(Schedule *)schedule order:(Order *)order {
    const NSTimeInterval orderTime = 600;
    return [[schedule endTime] timeIntervalSinceDate:[order inTime]] <= orderTime;
}

+ (bool)validate:(Schedule *)schedule forOrder:(Order *)order {
    return [self validateWaitTime:schedule] && [self validateOrderTime:schedule order:order];
}

@end