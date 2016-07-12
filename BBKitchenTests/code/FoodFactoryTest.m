
#import <XCTest/XCTest.h>
#import "FoodFactory.h"
#import "FoodItem.h"
#import <OCHamcrest/OCHamcrest.h>

@interface FoodFactoryTest : XCTestCase

@end

@implementation FoodFactoryTest


- (void)testExample {

    FoodItem *item = [[FoodFactory sharedInstance] getFoodItemForName:@"Haddock"];
    assertThat(item.name, is(@"Haddock"));
}


@end
