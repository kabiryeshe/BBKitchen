#import <Foundation/Foundation.h>
#import "Fryer.h"

typedef NS_ENUM(NSInteger, FoodType){
    FISH,
    CHIPS
};


@interface FoodItem : NSObject

@property(readonly, nonatomic) NSTimeInterval timeToCook;
@property(readonly) FryerType appropriateFryer;
@property(readonly) NSString * name;
@property(readonly) FoodType foodType;

- (instancetype)initWithTimeToCook:(NSTimeInterval)timeToCook
                  appropriateFryer:(FryerType)appropriateFryer
                              name:(NSString *)name
                          foodType:(FoodType)foodType;

@end