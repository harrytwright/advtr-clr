//
//  ADVLogger.h
//  ADVColorPalette
//
//  Created by Harry Wright on 13/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#ifndef ADVLogger_h
#define ADVLogger_h

#define ADVLog(frmt, ...)                                                                           \
    do {                                                                                            \
        if ([[ADVArgParser defaultParser] getObjectWithFlag:@"verbose"] &&                          \
            (((ADVArgBoolean *)[[ADVArgParser defaultParser] getObjectWithFlag:@"verbose"]).value)) \
                NSLog((frmt), ##__VA_ARGS__);                                                       \
    } while (0);

#endif /* ADVLogger_h */
