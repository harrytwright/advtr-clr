//
//  main.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <unistd.h>

#import "ADVLogger.h"
#import "ADVUtils.h"

#import "ADVArgParser.h"
#import "ADVArgBoolean.h"
#import "ADVColorPalette.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        @try {
            ADVArgParser *parser = [ADVArgParser defaultParser];
            [parser addPathWithFlag:@"file" defaultValue:NULL help:@"Input theme file to be loaded and read"];
            [parser addPathWithFlag:@"output" defaultValue:NULL help:@"Output theme file"];
            [parser addStringWithFlag:@"keypath" defaultValue:@"scheme" help:@"The keypath for the raw color scheme"];
            [parser addBooleanWithFlag:@"verbose" defaultValue:[ADVArgBoolean falseValue] withHelp:@"Set the verbosity flag"];
            [parser parse:argc arguments:argv];

            ADVLog(@"Verbrosity set - %@", ADVArgParserGetter(@"verbose", ADVArgBoolean));

            NSString *keyPath = ADVArgParserGetter(@"keypath", NSString);
            NSURL *filePath = ADVArgParserGetter(@"file", NSURL);
            if (!filePath) [[NSException exceptionWithName:@"CLIError" reason:@"Invalid CLI arguments" userInfo:@{ @"CLI Argument": @"file" }] raise];

            NSError *error;
            ADVColorPalette *palette = [[[ADVColorPalette alloc] initWithFile:filePath] loadWithKeyPath:keyPath error:&error];

            if (error) {
                NSLog(@"%@", error);
                [[NSException exceptionWithName:error.domain reason:error.debugDescription userInfo:NULL] raise];
            }

            NSURL *output = ADVArgParserGetter(@"output", NSURL);
            if (!output) [[NSException exceptionWithName:@"CLIError" reason:@"Invalid CLI arguments" userInfo:@{ @"CLI Argument": @"output" }] raise];

            [palette generate:output withError:&error];

            if (error) {
                [[NSException exceptionWithName:error.domain reason:error.localizedDescription userInfo:NULL] raise];
            }

            NSLog(@"Created new palette file @ %@", output.path);
        } @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
            if (exception.userInfo) NSLog(@"%@", exception.userInfo);
            return 1;
        }

    }
    return 0;
}
