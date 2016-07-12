#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property(nonatomic, readonly)NSArray * scheduleItems;
@property(nonatomic, readonly)NSDate * endTime;

- (instancetype)initWithScheduleItems:(NSArray *)scheduleItems;
- (NSTimeInterval)totalTime;
- (Schedule *)shiftBy:(NSTimeInterval)difference;
- (Schedule *)mergeScheduleWith:(Schedule *)schedule;

@end