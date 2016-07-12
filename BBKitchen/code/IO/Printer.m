#import "Printer.h"
#import "Order.h"
#import "ScheduleItem.h"
#import "FoodItem.h"
#import "DateUtil.h"
#import "Schedule.h"


@implementation Printer

- (NSArray *)print:(Schedule *)schedule order:(Order *)order {
    
    NSMutableArray *output = [@[] mutableCopy];

    [output addObject:[NSString stringWithFormat:@"at %@, Order %@ Accepted", [DateUtil timeToString:
    order.inTime], order.orderId]];

    for (ScheduleItem *scheduleItem in schedule.scheduleItems) {
        NSString *timeString = [DateUtil timeToString:scheduleItem.startTime];
        NSString *string = [NSString stringWithFormat:@"at %@, Begin Cooking %u %@", timeString, scheduleItem.quantity, scheduleItem.foodItem.name];
        [output addObject:string];
    }

    ScheduleItem *lastItem = schedule.scheduleItems.lastObject;
    NSString *servingTimeString = [DateUtil timeToString:lastItem.endTime];
    [output addObject:[NSString stringWithFormat:@"at %@, Serve Order %@", servingTimeString, order.orderId]];

    for (NSString *line in output) {
        NSLog(@"%@", line);
    }
    return output;
}


- (void)printError:(NSError *)error order:(Order *)order {
    NSString *errorString = [NSString stringWithFormat:@"at %@, Order %@ Rejected", [DateUtil timeToString:order.inTime], order.orderId];
    NSLog(@"%@", errorString);
}
@end