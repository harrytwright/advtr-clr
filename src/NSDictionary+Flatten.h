//
//  NSDictionary+Flatten.h
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Flatten)

- (NSDictionary *)flatten;

- (NSDictionary *)flattenWithDeliminator:(NSString *)deliminator;

@end

NS_ASSUME_NONNULL_END
