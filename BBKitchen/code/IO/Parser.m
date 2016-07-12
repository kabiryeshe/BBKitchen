#import "Parser.h"
#import "Order.h"
#import "FoodFactory.h"
#import "OrderItem.h"
#import "DateUtil.h"


@implementation Parser

-(NSArray *)parseInput:(NSArray *)input {

    NSMutableArray *orders = [@[] mutableCopy];
    for (NSString *orderLine in input) {
        Order *order = [self parseOrder:orderLine];
        [orders addObject:order];
    }
    return orders; 
}
- (Order *)parseOrder:(NSString *)string {
    // Order #1, 12:00:00, 2 Cod, 4 Haddock, 3 Chips
    NSArray *array = [string componentsSeparatedByString:@","];

    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *orderId = [[array[0] stringByReplacingOccurrencesOfString:@"Order" withString:@""]stringByTrimmingCharactersInSet:whiteSpace];
    NSString *timeString = [array[1] stringByTrimmingCharactersInSet:whiteSpace];

    NSMutableArray *orderItems = [[NSMutableArray alloc]init];
    for(int i=2; i < [array count]; i++) {
        NSArray *orderItemString = [[array[i] stringByTrimmingCharactersInSet:whiteSpace] componentsSeparatedByString:@" "];
        NSUInteger quantity = (NSUInteger) [orderItemString[0] integerValue];
        FoodItem *item = [[FoodFactory sharedInstance] getFoodItemForName:orderItemString[1]];

        [orderItems addObject:[[OrderItem alloc] initWithFoodItem:item quantity:quantity]];
    }
    
    return [[Order alloc] initWithOrderId:orderId
                                   inTime:[DateUtil timeFromString:timeString]
                                    items:orderItems];

}

@end