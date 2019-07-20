//
//  FileUnit.h
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/31.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUnit : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameWithoutExten;
@property (nonatomic, strong) NSURL *urlPath;
@property (nonatomic, strong) NSString *stringPath;
@property (nonatomic, strong) NSString *directory;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *modifieDate;
@property (nonatomic, strong) NSNumber *fileSizeOfBytes;

- (instancetype)initWithContentsOfPath:(NSString*)path;
- (instancetype)initWithContentsOfUrl:(NSURL*)url;
@end

NS_ASSUME_NONNULL_END
