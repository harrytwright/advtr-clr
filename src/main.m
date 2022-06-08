//
//  main.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADVLogger.h"
#import "ADVArgParser.h"
#import "ADVColorPalette.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        @try {
            ADVArgParser *parser = [ADVArgParser defaultParser];
            [parser addPathWithFlag:@"file" defaultValue:NULL help:@"Input theme file to be loaded and read"];
            [parser addPathWithFlag:@"output" defaultValue:NULL help:@"Output theme file"];
            [parser addStringWithFlag:@"prefix" defaultValue:NULL help:@"Add a prefix to the color name"];
            [parser addStringWithFlag:@"keypath" defaultValue:@"scheme" help:@"The keypath for the raw color scheme"];
            [parser addBooleanWithFlag:@"elements" defaultValue:[ADVArgBoolean trueValue] withHelp:@"Set if elements should also be parsed"];
            [parser addBooleanWithFlag:@"help" defaultValue:[ADVArgBoolean falseValue] withHelp:@"Set if the help message shiuld be displayed"];
            [parser addBooleanWithFlag:@"verbose" defaultValue:[ADVArgBoolean falseValue] withHelp:@"Set the verbosity flag"];
            [parser addBooleanWithFlag:@"dry-run" defaultValue:[ADVArgBoolean falseValue] withHelp:@"Only log the values and don't create the `.clr` file"];
            [parser parse:argc arguments:argv];

            if ([ADVArgParserGetter(@"help", ADVArgBoolean) value]) {
                printf("%s\n", [ADVArgParser defaultParser].description.UTF8String);
                return 1;
            }

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

            if (![ADVArgParserGetter(@"dry-run", ADVArgBoolean) value]) NSLog(@"Created new palette file @ %@", output.path);
        } @catch (NSException *exception) {
            if (exception.name) printf("ERR! %s\n", exception.name.UTF8String);
            if (exception.reason)  printf("ERR! %s\n", exception.reason.UTF8String);

            printf("%s\n", [ADVArgParser defaultParser].description.UTF8String);
           
            return 1;
        }

    }
    return 0;
}
