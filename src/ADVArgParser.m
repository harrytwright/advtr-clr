//
//  ADVArgParser.m
//  ADVColorPalette
//
//  Created by Harry Wright on 12/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "ADVArgParser.h"

#include <getopt.h>

#import "ADVUtils.h"
#import "ADVArgBoolean.h"

@interface ADVArg : NSObject

@property (nonnull, assign) NSString *flag;

@property (nullable, assign) id value;

@property (nullable, assign) NSString *helpMessage;

@property ADVArgParserType type;

- (instancetype)initWithFlag:(NSString *)flag value:(id)value ofType:(ADVArgParserType)type withHelpMessage:(NSString * _Nullable)helpMessage;

@end

@implementation ADVArg

- (instancetype)initWithFlag:(NSString *)flag value:(id)value ofType:(ADVArgParserType)type withHelpMessage:(NSString * _Nullable)helpMessage {
    self = [super init];
    if (self) {
        self.flag = flag;
        self.value = value;
        self.type = type;
        self.helpMessage = helpMessage;
    }
    return self;
}

- (NSString *)description {
    // Todo: Trim this rather than using tabs
    return [NSString stringWithFormat:@"--%@\t\t%@", self.flag, self.helpMessage ? self.helpMessage : @""];
}

@end

static ADVArgParser * _defaultParser;

static dispatch_once_t onceToken;

@interface ADVArgParser ()

@property NSMutableArray<ADVArg *>* flags;

- (void)addFlag:(NSString *)flag ofType:(ADVArgParserType)type defaultValue:(nullable id)defaultValue withHelp:(nullable NSString *)helpMessage;

@end

@implementation ADVArgParser

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flags = [NSMutableArray array];
    }
    return self;
}

+ (instancetype) defaultParser {
    dispatch_once(&onceToken, ^{
        _defaultParser = [[ADVArgParser alloc] init];
    });
    return _defaultParser;
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString string];
    [self.flags enumerateObjectsUsingBlock:^(ADVArg * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendString:[NSString stringWithFormat:@"\t%@\n", obj.description]];
    }];

    return [NSString stringWithFormat:@"Advtr Color Palette creator\n\n  $ advtr-clr\n\nOptions:\n%@", str];
}

- (id)getObjectWithFlag:(NSString *)flag {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ADVArg *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.flag isEqualToString:flag];
    }];

    NSUInteger idx = [self.flags indexOfObjectPassingTest:^BOOL(ADVArg * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [predicate evaluateWithObject:obj];
    }];

    if (idx == NSNotFound) {
        return NULL;
    }

    return self.flags[idx].value;
}


- (void)addFlag:(NSString *)flag
         ofType:(ADVArgParserType)type
   defaultValue:(id)defaultValue
       withHelp:(NSString *)helpMessage
{

    [self.flags addObject:[[ADVArg alloc] initWithFlag:flag value:defaultValue ofType:type withHelpMessage:helpMessage]];
}

- (void)parse:(int)argc arguments:(const char * _Nonnull *)argv {
    static struct option options[] = { };

    [self.flags enumerateObjectsUsingBlock:^(ADVArg * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // For boolean we can assume we don't need to pass an argument
        struct option opt = { [obj.flag UTF8String], obj.type == ADVArgParserTypeBoolean ? no_argument : required_argument, 0, 0 };
        options[idx] = opt;
    }];

    int opt;

    while (1) {
        int idx = 0;

        opt = getopt_long(argc, argv, "", options, &idx);

        if (opt == -1)
            break;

        switch (opt) {
            case 0:
                /* If this option set a flag, do nothing else now. */
                if (options[idx].flag != 0)
                  break;

                [self handleOptions:options[idx]];
                break;
            default:
                return;
        }
    }
}

- (void)handleOptions:(struct option)opt {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(ADVArg *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.flag isEqualToString:[NSString stringWithUTF8String:opt.name]];
    }];

    NSUInteger idx = [self.flags indexOfObjectPassingTest:^BOOL(ADVArg * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [predicate evaluateWithObject:obj];
    }];

    if (idx == NSNotFound) {
        NSLog(@"Could not find arg - %s", opt.name);
        return;
    }

    ADVArg *arg = self.flags[idx];

    // Should probably raise an exception here
    if (arg.type != ADVArgParserTypeBoolean && !optarg) return;

    switch (arg.type) {
        case ADVArgParserTypeString: {
            arg.value = [NSString stringWithUTF8String:optarg];
            break;
        }
        case ADVArgParserTypeNumber: {
            arg.value = [NSNumber numberWithInt:atoi(optarg)];
            break;
        }
        case ADVArgParserTypeBoolean:
            arg.value = [ADVArgBoolean trueValue];
            break;
        case ADVArgParserTypePath: {
            arg.value = [NSURL fileURLWithPath:[NSString stringWithUTF8String:optarg]];
            break;
        }
        default:
            break;
    }
}

/* PATHS */

- (void)addPathWithFlag:(NSString *)flag {
    [self addPathWithFlag:flag defaultValue:NULL];
}

- (void)addPathWithFlag:(NSString *)flag defaultValue:(NSURL *)defaultValue {
    [self addPathWithFlag:flag defaultValue:defaultValue help:NULL];
}

- (void)addPathWithFlag:(NSString *)flag defaultValue:(NSURL *)defaultValue help:(NSString *)helpMessage {
    [self addFlag:flag ofType:ADVArgParserTypePath defaultValue:defaultValue withHelp:helpMessage];
}

/* NUMBERS */

- (void)addNumberWithFlag:(NSString *)flag {
    [self addNumberWithFlag:flag defaultValue:NULL];
}

- (void)addNumberWithFlag:(NSString *)flag defaultValue:(NSNumber *)defaultValue {
    [self addNumberWithFlag:flag defaultValue:defaultValue withHelp:NULL];
}

- (void)addNumberWithFlag:(NSString *)flag defaultValue:(NSNumber *)defaultValue withHelp:(NSString *)helpMessage {
    [self addFlag:flag ofType:ADVArgParserTypeNumber defaultValue:defaultValue withHelp:helpMessage];
}

/* STRINGS */

- (void)addStringWithFlag:(NSString *)flag {
    [self addStringWithFlag:flag defaultValue:NULL];
}

- (void)addStringWithFlag:(NSString *)flag defaultValue:(NSString *)defaultValue {
    [self addStringWithFlag:flag defaultValue:defaultValue help:NULL];
}

- (void)addStringWithFlag:(NSString *)flag defaultValue:(NSString *)defaultValue help:(NSString *)helpMessage {
    [self addFlag:flag ofType:ADVArgParserTypeString defaultValue:defaultValue withHelp:helpMessage];
}

/* BOOLEAN */

- (void)addBooleanWithFlag:(NSString *)flag {
    [self addBooleanWithFlag:flag defaultValue:[ADVArgBoolean falseValue]];
}

- (void)addBooleanWithFlag:(NSString *)flag defaultValue:(ADVArgBoolean *)defaultValue {
    [self addBooleanWithFlag:flag defaultValue:defaultValue withHelp:NULL];
}

- (void)addBooleanWithFlag:(NSString *)flag defaultValue:(ADVArgBoolean *)defaultValue withHelp:(NSString *)helpMessage {
    [self addFlag:flag ofType:ADVArgParserTypeBoolean defaultValue:defaultValue withHelp:helpMessage];
}

@end
