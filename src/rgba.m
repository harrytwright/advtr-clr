//
// Created by Harry Wright on 08/06/2022.
//

#include "rgba.h"

/**
 * Helpers
 * */

NSString *recursive(NSString *str, NSInteger count) {
    NSMutableString *v = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        [v appendString:str];
    }
    return v;
}

// Add ^$ if we encounter any errors, as this is a loose creation
NSRegularExpression *createHexRegex (NSError * __autoreleasing *error) {
    // ${r('([a-f0-9]{2})', 3)}
    return [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"#%@([a-f0-9]{2})?", recursive(@"([a-f0-9]{2})", 2)]
                                                options:NSRegularExpressionCaseInsensitive
                                                  error:error];
};

// Add ^$ if we encounter any errors, as this is a loose creation
NSRegularExpression *createRGBARegex (NSError **error) {
    return [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"rgba?\\(\\s*(\\d+)\\s*%@(?:,\\s*([\\d.]+))?\\s*\\)", recursive(@",\\s*(\\d+)\\s*", 2)]
                                                options:NSRegularExpressionCaseInsensitive
                                                  error:error];
}

//NSRegularExpression *hslaRegex (NSError **error) {
//    return [[NSRegularExpression alloc] initWithPattern:@"^hsla?\(\s*([\d.]+)\s*,\s*([\d.]+)%\s*,\s*([\d.]+)%(?:\s*,\s*([\d.]+))?\s*\)$"
//                                                options:NSRegularExpressionCaseInsensitive
//                                                  error:error];
//}

/**
 * RGBA Inits
 * */

RGBA init_rgba(NSArray<NSNumber *> *arr) {
    // Create a default color to start with
    __block RGBA rgba = init_default_rgba();
    [arr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                rgba.red = obj.floatValue;
                break;
            case 1:
                rgba.green = obj.floatValue;
                break;
            case 2:
                rgba.blue = obj.floatValue;
                break;
            case 3:
                rgba.alpha = obj.floatValue;
                break;
        }
    }];
    return rgba;
}

/**
 * Creates a looser RGBA colour from a NSString, from either hex or RGB(A), it will match the first color
 * it finds in the string, so it will work w/ css shadows and borders
 * */
RGBA init_string_rgba(NSString *color) {
    if ([color isEqual: @""]) [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Color must be valid" userInfo:NULL] raise];
    if ([[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual: @"transparent"]) return init_clear_rgba();

    NSString *normalised = [color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSError *error = NULL;
    NSRegularExpression *hexRegex = createHexRegex(&error);
    if (error != NULL) [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Error setting up hex regex" userInfo:NULL] raise];

    // Check the matches
    NSArray<NSTextCheckingResult *> *hexMatches = [hexRegex matchesInString:normalised
                                                                    options:0
                                                                      range:NSMakeRange(0, normalised.length)];
    if (hexMatches.count > 0) {
        NSMutableArray<NSNumber *> *colors = [NSMutableArray array];
//        NSLog(@"hex matches - %@", hexMatches);
        for (NSTextCheckingResult *match in hexMatches) {
            int captureIndex;
            for (captureIndex = 1; captureIndex < match.numberOfRanges; captureIndex++) {
                NSRange matchRange = [match rangeAtIndex:captureIndex];
                [colors addObject:[NSNumber numberWithDouble:(double) strtol([[normalised substringWithRange:matchRange] UTF8String], NULL, 16) / 255.0]];
//                NSLog(@"value - %@", [colors lastObject]);
            }
        }

        return init_rgba([NSArray arrayWithArray:colors]);
    }

    NSRegularExpression *rgbaRegex = createRGBARegex(&error);
    if (error != NULL) [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Error setting up hex regex" userInfo:NULL] raise];

    // Check the matches
    NSArray<NSTextCheckingResult *> *rgbaMatches = [rgbaRegex matchesInString:normalised
                                                                      options:0
                                                                        range:NSMakeRange(0, normalised.length)];
    if (rgbaMatches.count > 0) {
        NSMutableArray<NSNumber *> *colors = [NSMutableArray array];
//        NSLog(@"rgba matches - %@", rgbaMatches);
        for (NSTextCheckingResult *match in rgbaMatches) {
            int captureIndex;
            for (captureIndex = 1; captureIndex < match.numberOfRanges; captureIndex++) {
                NSRange matchRange = [match rangeAtIndex:captureIndex];
                // We know that the 4th index, in an RGB(A) method will be already a decimal, so we can just / 1
                [colors addObject:[NSNumber numberWithDouble:(double) strtold([[normalised substringWithRange:matchRange] UTF8String], NULL) / (captureIndex == 4 ? 1.0 : 255.0 )]];
//                NSLog(@"value - %@", [colors lastObject]);
            }
        }

        return init_rgba([NSArray arrayWithArray:colors]);
    }

    return init_default_rgba();
}

RGBA init_clear_rgba(void) {
    RGBA rgba = {0, 0, 0, 0};
    return rgba;
}

RGBA init_default_rgba(void) {
    RGBA rgba = {1, 1, 1, 1};
    return rgba;
}

NSColor * create_nscolor_rgba(RGBA color) {
    return [NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha];
}
