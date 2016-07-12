#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FryerType){
    FISH_FRYER,
    CHIPS_FRYER
};

@interface Fryer : NSObject
@property(readonly) FryerType type;
@property(readonly) NSUInteger maxCapacity;
@property(readonly) NSUInteger currentLoad;

- (instancetype)initWithType:(FryerType)type capacity:(NSUInteger)capacity;
- (BOOL)isFull;
- (BOOL)add:(NSUInteger)quantity;
- (NSUInteger)remainingCapacity;
- (void)reset;
@end