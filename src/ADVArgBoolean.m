//
//  ADVArgBoolean.m
//  ADVColorPalette
//
//  Created by Harry Wright on 12/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "ADVArgBoolean.h"

@interface ADVArgBoolean ()

- (instancetype)initWithBooleanValue:(Boolean)boolean;

@end

@implementation ADVArgBoolean

- (instancetype)initWithBooleanValue:(Boolean)boolean {
    self = [super init];
    if (self) {
        self.value = boolean;
    }
    return self;
}

+ (instancetype)trueValue {
    return [[ADVArgBoolean alloc] initWithBooleanValue:YES];
}

+ (instancetype)falseValue {
    return [[ADVArgBoolean alloc] initWithBooleanValue:NO];
}

- (NSString *)description {
    return self.value == YES ? @"true" : @"false";
}

@end
