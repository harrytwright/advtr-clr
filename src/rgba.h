//
// Created by Harry Wright on 08/06/2022.
//

#ifndef ADVTR_CLR_RGBA_H
#define ADVTR_CLR_RGBA_H

#import <Cocoa/Cocoa.h>

typedef struct RGBA {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
} RGBA;

RGBA init_rgba(NSArray<NSNumber *> *arr);

RGBA init_string_rgba(NSString *color);

RGBA init_default_rgba(void);

RGBA init_clear_rgba(void);

NSColor * create_nscolor_rgba(RGBA color);

#endif //ADVTR_CLR_RGBA_H
