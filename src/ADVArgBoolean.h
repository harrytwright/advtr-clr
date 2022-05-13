//
//  ADVArgBoolean.h
//  ADVColorPalette
//
//  Created by Harry Wright on 12/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADVArgBoolean : NSObject

@property (readwrite) Boolean value;

+ (instancetype)trueValue;

+ (instancetype)falseValue;

@end

NS_ASSUME_NONNULL_END
