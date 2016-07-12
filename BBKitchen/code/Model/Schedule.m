#import "NSMutableArray+Stack.h"
#import "Schedule.h"
#import "ScheduleItem.h"

@interface Schedule ()
@property(nonatomic, readwrite)NSArray * scheduleItems;
@property(nonatomic, readwrite)NSDate * endTime;
@end

@implementation Schedule

- (instancetype)initWithScheduleItems:(NSArray *)scheduleItems {
    self = [super init];
    if (self) {
        _scheduleItems = scheduleItems;
    }

    return self;
}

- (Schedule *)shiftBy:(NSTimeInterval)interval {

    NSMutableArray* shiftedItems = [@[] mutableCopy];

    for (ScheduleItem * item in self.scheduleItems) {
        [shiftedItems addObject:[item shiftByInterval:interval]];
    }
    self.scheduleItems = shiftedItems;
    self.endTime = [self.endTime dateByAddingTimeInterval:interval];
    return self;
}

- (NSDate *)endTime {
    if(nil == _endTime) {
        _endTime = [self.scheduleItems.firstObject endTime];
        for (ScheduleItem *item in self.scheduleItems) {
            if ([item.endTime compare:_endTime] == NSOrderedDescending) {
                _endTime = item.endTime;
            }
        }

    }
    return _endTime;
}

- (NSTimeInterval)totalTime {
    return [[self endTime]timeIntervalSinceDate:[self startTime]];
}

- (NSDate *)startTime {
    ScheduleItem *firstItem = self.scheduleItems.firstObject;
    return [firstItem startTime];
}


- (Schedule *)mergeScheduleWith:(Schedule *)schedule {
    NSArray *allItems = [self.scheduleItems arrayByAddingObjectsFromArray:schedule.scheduleItems];
    NSArray *sortedItems = [allItems sortedArrayUsingComparator:^NSComparisonResult(ScheduleItem *obj1, ScheduleItem *obj2) {
        return obj1.startTime > obj2.startTime ? NSOrderedAscending : NSOrderedDescending;
    }];
    Schedule *mergedSchedule = [[Schedule alloc] initWithScheduleItems:sortedItems];
    return mergedSchedule;
}

@end