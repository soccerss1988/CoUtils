//
//  NSDictionary+Enhance.m
//  DevTools
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "NSDictionary+Enhance.h"

@implementation NSDictionary (Enhance)
- (NSData*)toData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSDictionary*)getJSONwithContenFilePath:(NSString*)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(json) {
        return json;
    }
    return nil;
}

@end
