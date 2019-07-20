//
//  NSDictionary+Enhance.h
//  DevTools
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Enhance)
- (NSData*)toData;
- (NSDictionary*)getJSONwithContenFilePath:(NSString*)filePath;
@end

NS_ASSUME_NONNULL_END
