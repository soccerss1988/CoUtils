//
//  SecurityManager.h
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecurityManager : NSObject
- (instancetype)shared;

- (NSData*)encryptArray:(NSArray*)array;
- (NSArray*)decryDataToArray:(NSData*)encryptData;

- (NSData*)encryptString:(NSString*)string;
- (NSString*)decryDataToString:(NSData*)encryptData;

- (NSData*)encryptDictionary:(NSDictionary*)dictionary;
- (NSDictionary*)decryDataToDictionary:(NSData*)encryptData;

- (NSData*)encryptData:(NSData*)data;
- (NSData*)decryptData:(NSData*)encryptData;

//keyChain

//https://www.jianshu.com/p/6b80b3b61984


@end
NS_ASSUME_NONNULL_END
