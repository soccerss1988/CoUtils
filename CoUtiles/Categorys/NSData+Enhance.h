//
//  NSData+Enhance.h
//  DevTools
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Enhance)
- (NSData *)AES256_encrypt:(NSString *)key;
- (NSData *)AES256_decrypt:(NSString *)key;

- (NSString*)dataToString;
- (NSArray*)dataToArray;
- (NSDictionary*)dataToDictionary;
@end

NS_ASSUME_NONNULL_END
