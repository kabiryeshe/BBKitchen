#import "Printer.h"
#import "DateUtil.h"


@implementation DateUtil

+ (NSDate *)timeFromString:(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter dateFromString:timeString];
}

+ (NSString *)timeToString:(NSDate *)time {

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:time];
}

+ (NSDate *)addTime:(NSTimeInterval)time {
    NSDate *date = [self timeFromString:@"12:10:00"];
    NSDate *interval = [date dateByAddingTimeInterval:time];
    return interval;
}

+(NSDate *)maximumOf:(NSDate *)time1 and:(NSDate *)time2 {

    return [time1 compare:time2] == NSOrderedDescending ? time1 : time2;
}

@end