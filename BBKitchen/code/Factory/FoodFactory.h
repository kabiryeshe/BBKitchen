#import <Foundation/Foundation.h>

@class FoodItem;

@interface FoodFactory : NSObject

+ (FoodFactory *)sharedInstance;

- (FoodItem *)getFoodItemForName:(NSString *)itemName;

@end