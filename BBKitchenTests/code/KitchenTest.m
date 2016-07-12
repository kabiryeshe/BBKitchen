#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Kitchen.h"
#import "Order.h"
#import "OrderItem.h"
#import "FoodFactory.h"
#import "ScheduleItem.h"
#import "FoodItem.h"
#import "FryerFactory.h"
#import "Schedule.h"
#import "DateUtil.h"
#import "Scheduler.h"

@interface KitchenTest : XCTestCase

@property(nonatomic, strong) NSDate *inTime;
@end

@interface KitchenTest ()
@property(nonatomic, strong) OrderItem *orderItem1;
@property(nonatomic, strong) OrderItem *orderItem2;
@property(nonatomic, strong) FoodItem *codFish;
@property(nonatomic, strong) FoodItem *haddockFish;
@property(nonatomic, strong) Kitchen *kitchen;
@property(nonatomic, strong) FoodItem *chips;
@property(nonatomic, strong) NSError *error;
@end

@implementation KitchenTest
//Haddock = 90 Cod = 80
- (void)setUp {
    [super setUp];
    self.codFish = [[FoodFactory sharedInstance] getFoodItemForName:@"Cod"];
    self.haddockFish = [[FoodFactory sharedInstance] getFoodItemForName:@"Haddock"];
    self.chips = [[FoodFactory sharedInstance] getFoodItemForName:@"Chips"];


    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.codFish quantity:4];
    self.orderItem2 = [[OrderItem alloc] initWithFoodItem:self.haddockFish quantity:4];

    _inTime = [DateUtil timeFromString:@"00:00:00"];

    self.kitchen = [[Kitchen alloc] initWithScheduler:[[Scheduler alloc] initWithFryerFactory:[FryerFactory sharedInstance] time:NULL]];

    [[[FryerFactory sharedInstance] getFryerForType:0] reset];
    [[[FryerFactory sharedInstance] getFryerForType:1] reset];

}


- (void)testThatItSchedulesOneItem {

    NSUInteger quantity = 3;
    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.codFish quantity:quantity];

    Order *order = [[Order alloc] initWithOrderId:@"123"
                                           inTime:self.inTime
                                            items:@[self.orderItem1]];
    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:order error:&error];
    assertThat(schedule.scheduleItems, hasCountOf(1));
    ScheduleItem *first = schedule.scheduleItems.firstObject;
    assertThat(first.startTime, is(self.inTime));
    assertThat(first.foodItem, is(self.codFish));
    assertThatInteger(first.quantity, equalToInteger(quantity));
    NSDate *endTime = [self.inTime dateByAddingTimeInterval:self.codFish.timeToCook];
    assertThat(first.endTime, is(endTime));
}

- (void)testThatItSchedulesTwoItemsWithCapacityAsFryersMaximumCapacity {

    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:_inTime
                                                                           items:@[self.orderItem1, self.orderItem2]] error:&error];
    assertThat(schedule.scheduleItems, hasCountOf(2));

    NSDate *expectedStartTime = _inTime;
    NSDate *expectedEndTime = [expectedStartTime dateByAddingTimeInterval:self.haddockFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.firstObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.haddockFish
                quantity:4];

    expectedStartTime = expectedEndTime;
    expectedEndTime = [expectedStartTime dateByAddingTimeInterval:self.codFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.lastObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:4];
}

- (void)testScheduleWhenItemQuantityMoreThanFryerCapacity {

    int quantity = 6;
    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.codFish quantity:quantity];

    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:_inTime
                                                                           items:@[self.orderItem1]] error:&error];
    assertThat(schedule.scheduleItems, hasCountOf(2));

    NSDate *expectedStartTime = _inTime;
    NSDate *expectedEndTime = [expectedStartTime dateByAddingTimeInterval:self.codFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.firstObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:4];

    NSLog(@"---------------------");

    expectedStartTime = expectedEndTime;
    expectedEndTime = [expectedStartTime dateByAddingTimeInterval:self.codFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.lastObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:2];
}


- (void)testScheduleWhenTwoItemsButCapacityLessThanFryerMaximumCapacity {

    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.codFish quantity:2];
    self.orderItem2 = [[OrderItem alloc] initWithFoodItem:self.haddockFish quantity:2];

    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:_inTime
                                                                           items:@[self.orderItem1, self.orderItem2]] error:&error];
    assertThat(schedule.scheduleItems, hasCountOf(2));

    NSDate *expectedStartTime = _inTime;
    NSDate *expectedEndTime = [_inTime dateByAddingTimeInterval:self.haddockFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.firstObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.haddockFish
                quantity:2];

    NSLog(@"----------------------");

    [self assertSchedule:schedule.scheduleItems.lastObject
               startTime:[_inTime dateByAddingTimeInterval:10]
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:2];
}


- (void)testScheduleWhenTwoItemsButCapacityofOneMoreThanFryerCapacity {

    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.codFish quantity:6];
    self.orderItem2 = [[OrderItem alloc] initWithFoodItem:self.haddockFish quantity:2];

    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:_inTime
                                                                           items:@[self.orderItem1, self.orderItem2]] error:&error];
    assertThat(schedule.scheduleItems, hasCountOf(3));

    NSDate *expectedStartTime = _inTime;
    NSDate *expectedEndTime = [_inTime dateByAddingTimeInterval:self.haddockFish.timeToCook];


    [self assertSchedule:schedule.scheduleItems.firstObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.haddockFish
                quantity:2];

    NSLog(@"2----------------------");

    [self assertSchedule:schedule.scheduleItems[1]
               startTime:[_inTime dateByAddingTimeInterval:10]
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:2];

    NSLog(@"3----------------------");

    expectedStartTime = expectedEndTime;
    expectedEndTime = [expectedStartTime dateByAddingTimeInterval:self.codFish.timeToCook];

    [self assertSchedule:schedule.scheduleItems.lastObject
               startTime:expectedStartTime
                 endTime:expectedEndTime
                foodItem:self.codFish
                quantity:4];

}


- (void)testScheduleWhenTwoItemsOfDifferentType {

    _inTime = [DateUtil timeFromString:@"00:00:00"];
    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.haddockFish quantity:4];
    self.orderItem2 = [[OrderItem alloc] initWithFoodItem:self.chips quantity:4];

    NSError* error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:_inTime
                                                                           items:@[self.orderItem1, self.orderItem2]]
                                            error:&error];

    assertThat(schedule.scheduleItems, hasCountOf(2));

    NSDate *expectedEndTime = [_inTime dateByAddingTimeInterval:self.chips.timeToCook];
    
    [self assertSchedule:schedule.scheduleItems.firstObject
               startTime:_inTime
                 endTime:expectedEndTime
                foodItem:self.chips
                quantity:4];

    [self assertSchedule:schedule.scheduleItems.lastObject
               startTime:[_inTime dateByAddingTimeInterval:30]
                 endTime:expectedEndTime
                foodItem:self.haddockFish
                quantity:4];

}


- (void)testRulesAreFailed {
    self.orderItem1 = [[OrderItem alloc] initWithFoodItem:self.chips quantity:12];
    NSError *error;
    Schedule *schedule = [self.kitchen placeOrder:[[Order alloc] initWithOrderId:@"123"
                                                                          inTime:[DateUtil timeFromString:@"00:00:00"]
                                                                           items:@[self.orderItem1]] error:&error];

    assertThat(error, isNot(nil));
}


- (void)assertSchedule:(ScheduleItem *)schedule startTime:(NSDate *)expectedStartTime endTime:(NSDate *)expectedEndTime foodItem:(FoodItem *)item quantity:(int)quantity {
    assertThat(schedule.startTime, is(expectedStartTime));
    assertThat(schedule.foodItem, is(item));
    assertThatInteger(schedule.quantity, equalToInteger(quantity));
    assertThat(schedule.endTime, is(expectedEndTime));
}


@end