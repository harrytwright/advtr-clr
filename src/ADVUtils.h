//
//  ADVArgs.h
//  ADVColorPalette
//
//  Created by Harry Wright on 12/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#ifndef ADVArgs_h
#define ADVArgs_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSURL *resolve(NSURL* filePath);

#define ADVArgParserGetter(flag, type) (type *)[[ADVArgParser defaultParser] getObjectWithFlag:(flag)]

NS_ASSUME_NONNULL_END

#endif /* ADVArgs_h */
