#import "FryerFactory.h"

@interface FryerFactory ()
@property(nonatomic) NSDictionary *fryers;
@end

@implementation FryerFactory

+ (FryerFactory *)sharedInstance {
    static dispatch_once_t once_token;
    static FryerFactory *factory;

    dispatch_once(&once_token, ^{
        factory = [[FryerFactory alloc] init];
        Fryer *fishFryer = [[Fryer alloc] initWithType:FISH_FRYER capacity:4];
        Fryer *chipsFryer = [[Fryer alloc] initWithType:CHIPS_FRYER capacity:4];

        NSDictionary *fryers = @{@(FISH_FRYER) : fishFryer,
                                @(CHIPS_FRYER) : chipsFryer};
        [factory setFryers:fryers];
    });
    return factory;
}

- (Fryer *)getFryerForType:(FryerType)type {
    return [self.fryers objectForKey:@(type)];
}


@end