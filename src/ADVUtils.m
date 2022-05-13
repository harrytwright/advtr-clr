//
//  ADVUtils.m
//  ADVColorPalette
//
//  Created by Harry Wright on 13/05/2022.
//  Copyright © 2022 Harry Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

NSURL *resolve(NSURL* filePath) {
//    [NSProcessInfo cur]
    NSURL *cwd = [NSURL fileURLWithPath:[NSString stringWithUTF8String:getenv("PWD")]];
    NSLog(@"%@", filePath.absoluteURL);
    return [cwd URLByAppendingPathComponent:filePath.absoluteString];
    return [NSURL fileURLWithPath:filePath.absoluteString relativeToURL:cwd];
}
