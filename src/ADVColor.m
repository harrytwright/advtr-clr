//
//  ADVColor.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "ADVColor.h"

#import <CoreImage/CoreImage.h>

NSString *rgba(NSColor *color) {
    return [NSString stringWithFormat:@"rgba(%.0f, %.0f, %.0f, %.0f)",
            color.redComponent * 255.0,
            color.greenComponent * 255.0,
            color.blueComponent * 255.0,
            color.alphaComponent * 255.0];
}

struct RGB {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} RGB;

struct RGB colorConverter(int hexValue) {
    struct RGB rgbColor;
    rgbColor.red = ((hexValue >> 16) & 0xFF) / 255.0;   // Extract the RR byte
    rgbColor.green = ((hexValue >> 8) & 0xFF) / 255.0;  // Extract the GG byte
    rgbColor.blue = ((hexValue) & 0xFF) / 255.0;        // Extract the BB byte

    return rgbColor;
}

@interface ADVColor ()

@property NSString *key;

@property NSColor *color;

@end

@implementation ADVColor

- (id)initWithColor:(NSString *)key withValue:(NSString *)value {
    self = [super init];
    if (self) {
        self.key = key;

        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wall"
        struct RGB rgb = colorConverter(strtol([[value stringByReplacingOccurrencesOfString:@"#" withString:@""] UTF8String], NULL, 16));
        #pragma GCC diagnostic pop
        self.color = [NSColor colorWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:1];
    }
    return self;
}

+ (id)color:(NSString *)key withValue:(NSString *)value {
    return [[self alloc] initWithColor: key withValue:value];
}

- (NSString *)description {
//    CGColorRef ref = [self.color CGColor];
    return [NSString stringWithFormat:@"%@ - %@", self.key, rgba(self.color)];
}

@end
