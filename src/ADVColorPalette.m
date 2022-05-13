//
//  ADVColorPalette.m
//  ADVColorPalette
//
//  Created by Harry Wright on 11/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import "ADVColorPalette.h"

#import "ADVColor.h"
#import "ADVUtils.h"
#import "ADVLogger.h"
#import "ADVArgParser.h"
#import "NSDictionary+Flatten.h"

@interface ADVColorPalette ()

@property NSURL *filePath;

@property (nullable) NSDictionary *scheme;

@end

@implementation ADVColorPalette

- (id)initWithFile:(NSURL *)filePath {
    self = [super init];
    if (self) {
        self.filePath = filePath;

        self.scheme = NULL;
    }
    return self;
}

- (instancetype)loadWithKeyPath:(NSString *)keyPath error:(NSError * _Nullable __autoreleasing *)error {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSLog(@"file - %@", self.filePath.absoluteString);

//    [[NSFileManager defaultManager] exis]
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath.path]) {
        *error = [NSError errorWithDomain:@"ADVColorPalette"
                                     code:1
                                 userInfo:@{
                                     NSDebugDescriptionErrorKey: @"Missing file",
                                     @"FilePath": self.filePath.absoluteString
                                 }];
        return self;
    }

    ADVLog(@"Opening file @ %@", self.filePath.absoluteString);
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:self.filePath.path];
    [stream open];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithStream:stream options:NSJSONReadingAllowFragments error:error];

    // Set the scheme
    if (data) {
        ADVLog(@"Getting scheme data w/ keypath \"%@\"", keyPath);
        self.scheme = [data valueForKeyPath:keyPath];
    }

    return self;
}

- (void)generate:(NSURL *)filePath withError:(NSError * _Nullable *)error {
    ADVLog(@"Creating NSColorList %@", [filePath.lastPathComponent stringByDeletingPathExtension]);
    NSColorList *colorList = [[NSColorList alloc] initWithName:[filePath.lastPathComponent stringByDeletingPathExtension]];
    NSDictionary *flattenedDictionary = [self.scheme flattenWithDeliminator:@"-"];

    NSArray *keys = [[flattenedDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        ADVLog(@"Adding color - %@", [ADVColor color:key withValue:[flattenedDictionary objectForKey:key]]);
        [colorList setColor:[[ADVColor color:key withValue:[flattenedDictionary objectForKey:key]] color] forKey:key];
    }

    ADVLog(@"Writng NSColorList file @ %@", filePath.absoluteString);
    [colorList writeToURL:filePath error:error];
}

@end
