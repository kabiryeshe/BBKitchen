#import <Foundation/Foundation.h>
#import "Fryer.h"

@class Fryer;

@interface FryerFactory : NSObject

+ (FryerFactory *)sharedInstance;
- (Fryer *)getFryerForType:(FryerType)type;

@end