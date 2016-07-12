#import "Order.h"
#import "NSMutableArray+Stack.h"
#import "FoodItem.h"
#import "OrderItem.h"
#import "ScheduleItem.h"
#import "Scheduler.h"
#import "Schedule.h"
#import "ScheduleRules.h"
#import "FryerFactory.h"
#import "DateUtil.h"

@interface Scheduler ()
@property(nonatomic) FryerFactory *fryerFactory;
@property(nonatomic) NSDate* currentTime;
@end

@implementation Scheduler

- (instancetype)initWithFryerFactory:(FryerFactory *)fryerFactory time:(NSDate *)time {
    self = [super init];
    if (self) {
        _fryerFactory = fryerFactory;
        _currentTime = time;
    }
    return self;
}


- (Schedule *)scheduleOrder:(Order *)order error:(NSError **)outError {
    NSDictionary *fryerGroupedItems = [self groupItemByFryers:order.items];
    NSMutableArray *fryerSchedules = [@[] mutableCopy];

    //Generating schedule per fryer
    for (NSNumber *fryerTypeKey in fryerGroupedItems) {
        Fryer *fryer = [self.fryerFactory getFryerForType:(FryerType) [fryerTypeKey integerValue]];
        Schedule *schedule = [self getSchedule:fryer items:fryerGroupedItems[fryerTypeKey] order:order];
        if (nil != *outError) {
            break;
        }
        [fryerSchedules addObject:schedule];

    }

    for (Schedule *schedule in fryerSchedules) {
        bool isValid = [ScheduleRules validate:schedule forOrder:order];
        if (!isValid) {
            *outError = [NSError errorWithDomain:@"Scheduling Error" code:101 userInfo:nil];
            return nil;
        }
    }

    Schedule *schedule = [Scheduler mergeSchedules:[Scheduler adjustScheduleToFinishOnSameTime:fryerSchedules]];
    self.currentTime = [schedule endTime];
    return schedule;
}

- (NSDictionary *)groupItemByFryers:(NSArray *)items {

    NSMutableDictionary *fryerGroup = [[NSMutableDictionary alloc] init];
    for (OrderItem *item in items) {
        NSNumber *key = @(item.foodItem.appropriateFryer);
        NSMutableArray *groupItems = fryerGroup[key];
        if (groupItems) {
            [groupItems addObject:item];
        } else {
            groupItems = [@[item] mutableCopy];
        }
        fryerGroup[key] = groupItems;
    }
    return fryerGroup;
}


- (Schedule *)getSchedule:(Fryer *)fryer items:(NSArray *)items order:(Order*)order{

    NSMutableArray *sortedItemsToSchedule = [[items sortedArrayUsingComparator:^NSComparisonResult(OrderItem *item1, OrderItem *item2) {
        return item1.foodItem.timeToCook < item2.foodItem.timeToCook ? NSOrderedDescending : NSOrderedAscending;
    }] mutableCopy];

    NSDate *fryerClock = [DateUtil maximumOf:_currentTime and:order.inTime];
    NSTimeInterval startInterval = 0;
    NSTimeInterval endInterval = 0;

    NSMutableArray *fryerSchedule = [@[] mutableCopy];

    while (0 != [sortedItemsToSchedule count]) {
        OrderItem *orderItem = [sortedItemsToSchedule pop];

        if ([fryer isFull]) {
            [fryer reset];
            startInterval = endInterval;
        } else {
            //If there is remaining capacity in fryer after previous batch
            if ([fryerSchedule count] > 0) {
                ScheduleItem *schedule = fryerSchedule.lastObject;
                startInterval += schedule.foodItem.timeToCook - orderItem.foodItem.timeToCook;
            }
        }

        endInterval = startInterval + orderItem.foodItem.timeToCook;

        NSUInteger quantityAdded = MIN([fryer remainingCapacity], orderItem.quantity);
        [fryer add:quantityAdded];

        ScheduleItem *schedule = [[ScheduleItem alloc] initWithStartTime:[fryerClock dateByAddingTimeInterval:startInterval]
                                                                 endTime:[fryerClock dateByAddingTimeInterval:endInterval]
                                                                   fryer:fryer
                                                                foodItem:orderItem.foodItem
                                                                quantity:quantityAdded];

        [fryerSchedule addObject:schedule];

        NSUInteger remainingQuantity = orderItem.quantity - quantityAdded;
        if (remainingQuantity > 0) {

            OrderItem *updatedOrderItem = [[OrderItem alloc] initWithFoodItem:orderItem.foodItem
                                                                     quantity:remainingQuantity];
            [sortedItemsToSchedule push:updatedOrderItem];
        }

    }
    [fryer reset];
    Schedule *schedule = [[Schedule alloc] initWithScheduleItems:fryerSchedule];
    return schedule;
}


#pragma Schedule processing methods


+ (void)adjustScheduleToFinishOnSameTime:(Schedule *)schedule1 withSchedule:(Schedule *)schedule2 {
    NSComparisonResult result = [[schedule1 endTime] compare:[schedule2 endTime]];
    Schedule *earlierSchedule;
    Schedule *laterSchedule;
    if (result == NSOrderedAscending) {
        earlierSchedule = schedule1;
        laterSchedule = schedule2;
    }
    if (result == NSOrderedDescending) {
        earlierSchedule = schedule2;
        laterSchedule = schedule1;
    }

    if (earlierSchedule && laterSchedule) {
        NSTimeInterval timeDifference = [[laterSchedule endTime] timeIntervalSinceDate:[earlierSchedule endTime]];
        [earlierSchedule shiftBy:timeDifference];
    }
}

+ (Schedule *)mergeSchedules:(NSArray *)schedules {
    //Designed for 2 fryers only. In case of more, it needs to updated.
    if ([schedules count] == 2) {
        return [schedules.firstObject mergeScheduleWith:schedules.lastObject];
    }
    return schedules.firstObject;
}

+ (NSArray *)adjustScheduleToFinishOnSameTime:(NSArray *)schedules {

    //Designed for 2 fryers only. In case of more, it needs to updated.
    if ([schedules count] == 2) {
        Schedule *schedule1 = schedules.firstObject;
        Schedule *schedule2 = schedules.lastObject;

        NSComparisonResult result = [[schedule1 endTime] compare:[schedule2 endTime]];
        Schedule *earlierSchedule;
        Schedule *laterSchedule;
        if (result == NSOrderedAscending) {
            earlierSchedule = schedule1;
            laterSchedule = schedule2;
        }
        if (result == NSOrderedDescending) {
            earlierSchedule = schedule2;
            laterSchedule = schedule1;
        }

        if (earlierSchedule && laterSchedule) {
            NSTimeInterval timeDifference = [[laterSchedule endTime] timeIntervalSinceDate:[earlierSchedule endTime]];
            [earlierSchedule shiftBy:timeDifference];
        }
    }
    return schedules;
}

@end