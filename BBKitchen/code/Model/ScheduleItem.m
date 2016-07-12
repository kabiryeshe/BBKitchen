#import "ScheduleItem.h"


@implementation ScheduleItem

- (instancetype)initWithStartTime:(NSDate *)startTime
                          endTime:(NSDate *)endTime
                            fryer:(Fryer *)fryer
                         foodItem:(FoodItem *)foodItem
                         quantity:(NSUInteger)quantity {
    self = [super init];
    if (self) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.fryer = fryer;
        self.foodItem = foodItem;
        self.quantity = quantity;
    }

    return self;
}

- (ScheduleItem *)shiftByInterval:(NSTimeInterval)interval {
    self.startTime = [self.startTime dateByAddingTimeInterval:interval];
    self.endTime = [self.endTime dateByAddingTimeInterval:interval];
    return self;
}

@end