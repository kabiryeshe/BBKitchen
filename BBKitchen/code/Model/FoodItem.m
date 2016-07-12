
#import "FoodItem.h"

@implementation FoodItem

- (instancetype)initWithTimeToCook:(NSTimeInterval)timeToCook
                  appropriateFryer:(FryerType)appropriateFryer
                              name:(NSString *)name
                          foodType:(FoodType)foodType {
    self = [super init];
    if (self) {
        _timeToCook = timeToCook;
        _appropriateFryer = appropriateFryer;
        _name = name;
        _foodType = foodType;
    }

    return self;
}

@end