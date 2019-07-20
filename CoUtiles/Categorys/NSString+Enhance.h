//
//  NSString+Enhance.h
//  DevTools
//
//  Created by YJ Huang on 2019/3/21.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Enhance)
- (NSData*)toData;
- (NSString*)toBase64DecodeString;
- (NSString*)toBase64EncodeString;
- (NSString *) AES256_encrypt:(NSString *)key;
- (NSString *) AES256_decrypt:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
