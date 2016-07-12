#import "Order.h"
#import <XCTest/XCTest.h>
#import "FoodFactory.h"
#import "FoodItem.h"
#import "Parser.h"
#import "OrderItem.h"
#import "DateUtil.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMock/OCMock.h>

@interface ParserTest : XCTestCase

@end

@implementation ParserTest


- (void)testExample {


    Parser *parser = [[Parser alloc]init];
    id factory  = OCMClassMock([FoodFactory class)];

    FoodItem *item1  = OCMClassMock([FoodItem class)];
    FoodItem *item2  = OCMClassMock([FoodItem class)];
    FoodItem *item3  = OCMClassMock([FoodItem class)];

    OCMStub([factory sharedInstance]).andReturn(factory);
    OCMStub([factory getFoodItemForName:@"Cod"]).andReturn(item1);
    OCMStub([factory getFoodItemForName:@"Haddock"]).andReturn(item2);
    OCMStub([factory getFoodItemForName:@"Chips"]).andReturn(item3);

    Order *order = [parser parseOrder:@"Order #1, 12:00:00, 2 Cod, 4 Haddock, 3 Chips"];

    assertThat(order, isNot(nil));
    assertThat([DateUtil timeToString:order.inTime], is(@"12:00:00"));
    assertThat(order.items, hasCountOf(3));
    OrderItem *orderItem = order.items.firstObject;

    assertThatInteger(orderItem.quantity, equalToInt(2));
    assertThat(orderItem.foodItem, is(item1));
}


@end
