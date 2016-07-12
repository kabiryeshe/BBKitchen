#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)object {
    [self insertObject:object atIndex:0];
}

- (id)pop {
    id o = [self firstObject];
    if (o) {
        [self removeObjectAtIndex:0];
    }
    return o;
}


@end