#import <Foundation/Foundation.h>

@class Fryer;
@class FoodItem;


@interface ScheduleItem : NSObject

@property(nonatomic) NSDate *startTime;
@property(nonatomic) NSDate *endTime;
@property(nonatomic) Fryer *fryer;
@property(nonatomic) FoodItem *foodItem;
@property(nonatomic) NSUInteger quantity;

- (instancetype)initWithStartTime:(NSDate *)startTime
                          endTime:(NSDate *)endTime
                            fryer:(Fryer *)fryer
                         foodItem:(FoodItem *)foodItem
                         quantity:(NSUInteger)quantity;

- (ScheduleItem *)shiftByInterval:(NSTimeInterval)interval;

@end