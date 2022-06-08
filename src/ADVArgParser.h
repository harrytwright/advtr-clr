//
//  ADVArgParser.h
//  ADVColorPalette
//
//  Created by Harry Wright on 12/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADVUtils.h"
#import "ADVArgBoolean.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ADVArgParserType) {
    ADVArgParserTypePath,
    ADVArgParserTypeString,
    ADVArgParserTypeNumber,
    ADVArgParserTypeBoolean,
};

@interface ADVArgParser : NSObject

+ (instancetype) defaultParser;

- (nullable id)getObjectWithFlag:(NSString *)flag;

- (void)addPathWithFlag:(NSString *)flag;
- (void)addPathWithFlag:(NSString *)flag defaultValue:(nullable NSURL *)defaultValue;
- (void)addPathWithFlag:(NSString *)flag defaultValue:(nullable NSURL *)defaultValue help:(nullable NSString *)helpMessage;

- (void)addStringWithFlag:(NSString *)flag;
- (void)addStringWithFlag:(NSString *)flag defaultValue:(nullable NSString *)defaultValue;
- (void)addStringWithFlag:(NSString *)flag defaultValue:(nullable NSString *)defaultValue help:(nullable NSString *)helpMessage;

- (void)addNumberWithFlag:(NSString *)flag;
- (void)addNumberWithFlag:(NSString *)flag defaultValue:(nullable NSNumber *)defaultValue;
- (void)addNumberWithFlag:(NSString *)flag defaultValue:(nullable NSNumber *)defaultValue withHelp:(nullable NSString *)helpMessage;

- (void)addBooleanWithFlag:(NSString *)flag;
- (void)addBooleanWithFlag:(NSString *)flag defaultValue:(nullable ADVArgBoolean *)defaultValue;
- (void)addBooleanWithFlag:(NSString *)flag defaultValue:(nullable ADVArgBoolean *)defaultValue withHelp:(nullable NSString *)helpMessage;

- (void)parse:(int)argc arguments:(const char *_Nonnull *_Nonnull)argv;

@end

NS_ASSUME_NONNULL_END
