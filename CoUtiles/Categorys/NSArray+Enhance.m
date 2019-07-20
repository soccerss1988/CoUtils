//
//  NSArray+Enhance.m
//  DevTools
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "NSArray+Enhance.h"

@implementation NSArray (Enhance)
- (NSData*)toData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}
@end
