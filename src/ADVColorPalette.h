//
//  ADVColorPalette.h
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADVColorPalette : NSObject

- (id)init NS_UNAVAILABLE;

- (id)initWithFile:(NSURL *)filePath NS_DESIGNATED_INITIALIZER;

- (instancetype)loadWithKeyPath:(NSString *)keyPath error:(NSError * _Nullable *)error;

- (void)generate:(NSURL *)filePath withError:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
