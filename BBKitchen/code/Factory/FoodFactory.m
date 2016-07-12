#import "FoodFactory.h"
#import "FoodItem.h"

@interface FoodFactory()

@property(nonatomic) NSDictionary *foodItems;

@end

@implementation FoodFactory

+ (FoodFactory *)sharedInstance {
    static dispatch_once_t once_token;
    static FoodFactory *factory;

    dispatch_once(&once_token, ^{
        FoodItem *codFish = [[FoodItem alloc] initWithTimeToCook:80
                                                appropriateFryer:FISH_FRYER
                                                            name:@"Cod"
                                                        foodType:FISH];

        FoodItem *haddockFish = [[FoodItem alloc] initWithTimeToCook:90
                                                    appropriateFryer:FISH_FRYER
                                                                name:@"Haddock"
                                                            foodType:FISH];

        FoodItem *chips = [[FoodItem alloc] initWithTimeToCook:120
                                              appropriateFryer:CHIPS_FRYER
                                                          name:@"Chips"
                                                      foodType:CHIPS];

        NSDictionary *foodItems = [[NSDictionary alloc] initWithObjects:@[codFish, haddockFish, chips]
                                                                forKeys:@[@"Cod", @"Haddock", @"Chips"]];

        factory = [[FoodFactory alloc]init];
        [factory setFoodItems:foodItems];

    });
    return factory;
}

- (FoodItem *)getFoodItemForName:(NSString *)itemName {

    return [self.foodItems objectForKey:itemName];
}

@end