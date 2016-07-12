#import "Kitchen.h"
#import "Order.h"
#import "Scheduler.h"
#import "Schedule.h"

@interface Kitchen ()
@property(nonatomic) Scheduler *scheduler;
@end

@implementation Kitchen

- (instancetype)initWithScheduler:(Scheduler *)scheduler {
    self = [super init];
    if (self) {
        self.scheduler = scheduler;
    }

    return self;
}


- (NSArray *)placeOrders:(NSArray *)orders {
    NSMutableArray *schedules = [@[] mutableCopy];
    for (Order *order in orders) {
        NSError *error = nil;
        Schedule *schedule = [self.scheduler scheduleOrder:order error:&error];
        id object = error ? error: schedule;
        [schedules addObject:object];
    }
    return schedules;
}

- (Schedule *)placeOrder:(Order *)order error:(NSError**)error{

    return [self.scheduler scheduleOrder:order error:error];
}


@end