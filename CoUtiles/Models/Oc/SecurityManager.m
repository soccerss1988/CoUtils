//
//  SecurityManager.m
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/23.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "SecurityManager.h"
#import "NSData+Enhance.h"
#import "NSArray+Enhance.h"
#import "NSDictionary+Enhance.h"
#import "NSString+Enhance.h"
#define KEY @"DevEnhance"

@implementation SecurityManager
static SecurityManager *_sharedInstance = nil;
- (instancetype)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SecurityManager alloc]init];
    });
    return _sharedInstance;
}


//Array ency&decy
- (NSData*)encryptArray:(NSArray*)array {
    NSData *arrayData = [array toData];
    return [arrayData AES256_encrypt:KEY];
}

- (NSArray*)decryDataToArray:(NSData*)encryptData {
    NSData *decryData = [encryptData AES256_decrypt:KEY];
    return [decryData dataToArray];
}

//NSString ency&decy
- (NSData*)encryptString:(NSString*)string {
    NSData *stringData = [string toData];
    return [stringData AES256_encrypt:KEY];
}

- (NSString*)decryDataToString:(NSData*)encryptData {
    NSData *decryData = [encryptData AES256_decrypt:KEY];
    return [decryData dataToString];
}

//NSdictionary ency&decy
- (NSData*)encryptDictionary:(NSDictionary*)dictionary {
    NSData *dicData = [dictionary toData];
    return [dicData AES256_encrypt:KEY];
}

- (NSDictionary*)decryDataToDictionary:(NSData*)encryptData {
    NSData *decryData = [encryptData AES256_decrypt:KEY];
    return [decryData dataToDictionary];
}

//NSdata ency&decy
- (NSData*)encryptData:(NSData*)data {
    return [data AES256_encrypt:KEY];
}

- (NSData*)decryptData:(NSData*)encryptData {
    return [encryptData AES256_decrypt:KEY];
}

@end
