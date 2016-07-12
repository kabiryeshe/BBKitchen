#import <Foundation/Foundation.h>

@class FoodItem;

@interface OrderItem : NSObject

@property(nonatomic, readonly) FoodItem *foodItem;
@property(readonly)NSUInteger quantity;

- (instancetype)initWithFoodItem:(FoodItem *)foodItem quantity:(NSUInteger)quantity;

@end