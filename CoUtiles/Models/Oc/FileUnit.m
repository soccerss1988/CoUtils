//
//  FileUnit.m
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/31.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "FileUnit.h"

@interface FileUnit()
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation FileUnit


- (instancetype)initWithContentsOfPath:(NSString*)path {
    
    if([self init]) {
        self.name = path.lastPathComponent;
        self.nameWithoutExten = path.lastPathComponent.stringByDeletingPathExtension;
        self.stringPath = path;
        self.urlPath = [NSURL URLWithString:path];
        self.directory = path.stringByDeletingLastPathComponent;
        self.type = path.pathExtension;
    }
    return self;
}

- (instancetype)initWithContentsOfUrl:(NSURL *)url {
    NSString *stringPath = url.path;
    return [self initWithContentsOfPath:stringPath];
}

- (instancetype)init {
    
    if([super init]) {
        self.name = @"";
        self.nameWithoutExten = @"";
        self.urlPath = [NSURL URLWithString:@""];
        self.stringPath = @"";
        self.directory = @"";
        self.type = @"";
        self.createDate = @"";
        self.modifieDate = @"";
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

//MARK: Attributes
- (NSString*)createDate {
    return [self getAttributesWithKey:NSFileCreationDate];
}

- (NSString*)modifieDate {
    return [self getAttributesWithKey:NSFileModificationDate];
}


//- (NSNumber*)fileSizeOfBytes {
//
//    //Returns the file’s size, in bytes.
//    //- (unsigned long long)fileSize;
//    return [self getAttributesWithKey:NSFileSize];
//}

- (NSString*)getAttributesWithKey:(NSFileAttributeKey)key {
    NSDictionary *attributes = [self getfileAttributes];
    if(attributes) {
        return [attributes valueForKey:key];
    }
    return @"";
}

- (nullable NSDictionary<NSFileAttributeKey, id> *) fgetfileAttributes {
    return [self.fileManager attributesOfItemAtPath:self.stringPath error:nil];
}

//overwrite description
- (NSString*)description {
    
    return [NSString stringWithFormat:@"%@",@{@"fileName":self.name,
                                              @"StringPath":self.stringPath,
                                              @"URLPath":self.urlPath,
                                              @"Directory":self.directory,
                                              @"Type":self.type}];
}

@end
