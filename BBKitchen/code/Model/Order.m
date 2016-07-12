#import "Order.h"


@implementation Order

- (instancetype)initWithOrderId:(NSString *)orderId inTime:(NSDate *)inTime items:(NSArray *)items {
    self = [super init];
    if (self) {
        _orderId = orderId;
        _inTime = inTime;
        _items = items;
    }

    return self;
}


@end