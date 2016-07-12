#import "Fryer.h"


@interface Fryer ()
@property(readwrite) NSUInteger currentLoad;
@end

@implementation Fryer

- (instancetype)initWithType:(FryerType)type capacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _type = type;
        _maxCapacity = capacity;
    }

    return self;
}


//Fryer's state related method

- (BOOL)isFull {
    return self.currentLoad == self.maxCapacity;
}

- (BOOL)add:(NSUInteger)quantity {
    if([self isFull]) return NO;
    self.currentLoad += quantity;
    return YES;
}


- (NSUInteger)remainingCapacity {
    return self.maxCapacity - self.currentLoad ;
}

- (void)reset {
    self.currentLoad = 0;
}
@end