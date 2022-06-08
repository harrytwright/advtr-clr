//
//  ADVColor.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "ADVColor.h"
#import "rgba.h"

@interface ADVColor ()

@property NSString *key;
@property NSColor *color;

@end

static NSMutableDictionary<NSString*, ADVColor *> *colorCache = NULL;
static dispatch_once_t onceToken;

@implementation ADVColor

- (id)initWithColor:(NSString *)key withColor:(NSColor *)color {
    self = [super init];
    if (self) {
        self.key = key;
        self.color = color;
    }
    return self;
}

+ (id)color:(NSString *)key withValue:(NSString *)value {
    dispatch_once(&onceToken, ^{
        colorCache = [NSMutableDictionary dictionary];
    });

    // Saves us creating the element again, since there is only one way to create a color, and that's
    // by flattening the dictionary anyway, so we should never have two colors for the same key, saves
    // around 0.18ish when tested w/ $ time
    if ([colorCache valueForKey:key]) return [[colorCache valueForKey:key] copy];
    return [[self alloc] initWithColor: key withColor:create_nscolor_rgba(init_string_rgba(value))];
}

- (id)copy {
    return [[ADVColor alloc] initWithColor:self.key withColor:self.color];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.key, [NSString stringWithFormat:@"rgba(%.0f, %.0f, %.0f, %.0f)",
                                                             self.color.redComponent * 255.0,
                                                             self.color.greenComponent * 255.0,
                                                             self.color.blueComponent * 255.0,
                                                             self.color.alphaComponent * 255.0]];
}

@end
