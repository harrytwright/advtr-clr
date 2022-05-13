//
//  ADVColor.h
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADVColor : NSObject

@property (readonly) NSString *key;

@property (readonly) NSColor *color;

/*
 Create the color from the JSON object, these could be RGBA/HEX
 */
+ (id)color:(NSString *)key withValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
