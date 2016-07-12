#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(readonly, nonatomic) NSString *orderId;
@property(readonly, nonatomic) NSDate *inTime;
@property(readonly, nonatomic) NSArray *items;

- (instancetype)initWithOrderId:(NSString *)orderId inTime:(NSDate *)inTime items:(NSArray *)items;

@end