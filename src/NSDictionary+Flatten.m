//
//  NSDictionary+Flatten.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "NSDictionary+Flatten.h"
#import "Flatten.h"

@implementation NSDictionary (Flatten)

- (NSDictionary *)flatten {
    return [self flattenWithDeliminator:@"."];
}

- (NSDictionary *)flattenWithDeliminator:(NSString *)deliminator {
    return flatten(self, deliminator, ^id _Nonnull(id  _Nonnull key, id  _Nonnull value) {
        if ([key isKindOfClass:[NSNumber class]]) {
            return [[NSString stringWithString:[(NSNumber *) key stringValue]] stringByPaddingToLength:3 withString:@"0" startingAtIndex:0];
        }
        return key;
    });
}

@end
