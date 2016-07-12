#import <Foundation/Foundation.h>


@interface DateUtil : NSObject

+ (NSDate *)timeFromString:(NSString *)timeString;
+ (NSString *)timeToString:(NSDate *)time;
+ (NSDate *)addTime:(NSTimeInterval)time;

+ (NSDate *)maximumOf:(NSDate *)time1 and:(NSDate *)time2;
@end