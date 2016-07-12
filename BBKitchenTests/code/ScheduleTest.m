#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "ScheduleItem.h"
#import "FoodItem.h"
#import "DateUtil.h"
#import "Schedule.h"

@interface ScheduleTest : XCTestCase

@end

@implementation ScheduleTest


- (void)testThatEndTimeAndTotalTimeIsCalculatedCorrectly {
    ScheduleItem *item1 = [[ScheduleItem alloc] initWithStartTime:[DateUtil timeFromString:@"00:00:00"]
                                                          endTime:[DateUtil timeFromString:@"00:00:40"]
                                                            fryer:nil
                                                         foodItem:nil
                                                         quantity:0];
    NSDate *endTime = [DateUtil timeFromString:@"00:00:50"];
    ScheduleItem *item2 = [[ScheduleItem alloc] initWithStartTime:[DateUtil timeFromString:@"00:00:40"]
                                                          endTime:endTime
                                                            fryer:nil
                                                         foodItem:nil
                                                         quantity:0];
    
    Schedule *schedule = [[Schedule alloc] initWithScheduleItems:@[item1, item2]];
    assertThat([schedule endTime], is(endTime));
    assertThatDouble([schedule totalTime], equalToDouble(50));

}




@end