
#import <XCTest/XCTest.h>
#import "Printer.h"
#import "DateUtil.h"

@interface PrinterTest : XCTestCase

@end

@implementation PrinterTest

- (void)testExample {

    Printer *printer = [[Printer alloc]init];
    NSDate *date = [DateUtil addTime:120];
    NSString *string = [DateUtil timeToString:date];
    NSLog(@"Time | %@", string);
}

@end
