//
//  Flatten.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "Flatten.h"

typedef enum : NSUInteger {
    ADVDictionary,
    ADVArray,
} ADVType;

void enumerate(NSObject<NSFastEnumeration>* object, ADVEnumerationBlock block) {
    ADVType type;
    if ([object isKindOfClass:[NSDictionary class]]) {
        type = ADVDictionary;
    } else if ([object isKindOfClass:[NSArray class]]) {
        // In the array, fast enumeration returns the value not the index
        type = ADVArray;
    } else {
        [[NSException exceptionWithName:@"TypeError" reason:@"Invaid object type" userInfo:NULL] raise];
    }

    for (id keyOrValue in object) {
        id key = type == ADVArray ? [NSNumber numberWithUnsignedInteger:[(NSArray *)object indexOfObjectIdenticalTo:keyOrValue]] : keyOrValue;
        id value = type == ADVArray ? keyOrValue : [(NSDictionary *)object objectForKeyedSubscript:key];

        if (!value) {
            continue;
        }

        block(key, value);
    }
}

NSDictionary *flatten(NSObject<NSFastEnumeration>* obj, NSString * deliminator, __nullable ADVEnumerationBlockWithValue keyMap) {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    enumerate(obj, ^(id key, id value) {
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            NSDictionary *child = flatten(value, deliminator, keyMap);
            enumerate(child, ^(id childKey, id childValue) {
                [result setValue:childValue forKey:[NSString stringWithFormat:@"%@%@%@", keyMap ? keyMap(key, value) : key, deliminator, keyMap ? keyMap(childKey, childValue): childKey]];
            });
        } else {
            [result setValue:value forKey:key];
        }
    });

    return [NSDictionary dictionaryWithDictionary:result];
}
