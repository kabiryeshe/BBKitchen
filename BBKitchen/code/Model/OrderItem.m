#import "OrderItem.h"
#import "FoodItem.h"


@implementation OrderItem

- (instancetype)initWithFoodItem:(FoodItem *)foodItem quantity:(NSUInteger)quantity {
    self = [super init];
    if (self) {
        _foodItem = foodItem;
        _quantity = quantity;
    }

    return self;
}


@end