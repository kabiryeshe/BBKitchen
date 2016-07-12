
#import "BBMain.h"
#import "Parser.h"
#import "Kitchen.h"
#import "Printer.h"
#import "FryerFactory.h"
#import "Scheduler.h"
#import "Order.h"
#import "Schedule.h"


@interface BBMain ()
- (void)run;
@end

@implementation BBMain

- (void)run {

    NSArray *input1 = @[@"Order #1, 12:00:00, 2 Cod, 4 Haddock, 3 Chips",
            @"Order #2, 12:00:30, 1 Haddock, 1 Chips",
            @"Order #3, 12:01:00, 21 Chips"

    ];


    Parser *parser = [[Parser alloc] init];
    NSArray *orders = [parser parseInput:input];

    NSDate *startTime = [orders.firstObject inTime];

    Kitchen *kitchen = [[Kitchen alloc] initWithScheduler:[[Scheduler alloc] initWithFryerFactory:[FryerFactory sharedInstance] time:startTime]];
    NSArray *schedules = [kitchen placeOrders:orders];

    Printer *printer = [[Printer alloc] init];
    NSMutableArray *output = [@[] mutableCopy];
    for (NSUInteger i = 0; i < [orders count]; i++) {
        id item = schedules[i];
        if ([item isKindOfClass:[Schedule class]]) {
            [printer print:item order:orders[i]];
        } else {
            [printer printError:item order:orders[i]];
        }
    }

}


@end