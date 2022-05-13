//
//  Flatten.h
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#ifndef Flatten_h
#define Flatten_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ADVEnumerationBlock)(id key, id value);

typedef id _Nonnull (^ADVEnumerationBlockWithValue)(id key, id value);

extern NSDictionary *flatten(NSObject<NSFastEnumeration> *value, NSString * deliminator, __nullable ADVEnumerationBlockWithValue keyMap);

NS_ASSUME_NONNULL_END

#endif /* Flatten_h */
