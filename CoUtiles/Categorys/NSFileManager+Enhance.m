//
//  NSFileManager+Enhance.m
//  DevTools
//
//  Created by YJ Huang on 2019/3/19.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "NSFileManager+Enhance.h"

@implementation NSFileManager (Enhance)

- (NSString*)documentDirectory {
    return [self getDirectoryWithKey:NSDocumentDirectory];
}

- (NSString*)libraryDirectory {
    return [self getDirectoryWithKey:NSLibraryDirectory];
}

- (NSString*)cachesDirectory {
    return [self getDirectoryWithKey:NSCachesDirectory];
}

- (void)moveItemFromPath:(NSString*)oraginPath toPath:(NSString*)destinationPath errorHandler:(errorhandler)handler {
    NSError* error;
    if([self fileExistsAtPath:destinationPath])
    {
        [self removeItemAtPath:destinationPath error:&error];
        if(error) {
            handler(error,NO);
        }
    }
    
    [self moveItemAtPath:oraginPath toPath:destinationPath error:&error];
    if(error) {
        handler(error,NO);
    }
    handler(nil,YES);
}

//MARK: private method
- (NSString*)getDirectoryWithKey:(NSSearchPathDirectory)directoryKey {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documenstPath = searchPaths[0];
    return documenstPath;
}

- (NSArray*)getFileInfoFromContentOfFolerPath:(NSString*)forderPath fileType:(FileType)type {
    
    NSArray *filePaths = [self getFilePathsFromContentFolder:forderPath];
    NSString *filterRule = [NSString stringWithFormat:@"name CONTAINS '%@'",[self parsetFileType:type]];
    NSPredicate *prdicate = [NSPredicate predicateWithFormat:filterRule];
    NSArray *result = [filePaths filteredArrayUsingPredicate:prdicate];
    return result;
}

- (NSArray*)getFilePathsFromContentFolder:(NSString*)folderPath {
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:folderPath] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    return fileList;
}

- (BOOL)renameWithContentOfFilePath:(NSString*)path toName:(NSString*)newName error:(NSError**)error {
    NSString *oraginPath = path.stringByDeletingLastPathComponent;
    NSString *newPath = [oraginPath stringByAppendingPathComponent:newName];
    if([self moveItemAtPath:path toPath:newPath error:error]) {
        return YES;
    }
    return NO;
}


- (BOOL)createDirectory:(NSString*)direcotory removeExists:(BOOL)needRemve error:(NSError **)error{
    
    if([self fileExistsAtPath:direcotory]) {
        
        if(needRemve) {
            
            [self removeItemAtPath:direcotory error:nil];
            
            if([self createDirectoryAtPath:direcotory withIntermediateDirectories:YES attributes:nil error:error]) {
                return YES;
            }
        }
    }
    else {
        
        if([self createDirectoryAtPath:direcotory withIntermediateDirectories:YES attributes:nil error:error]) {
            return YES;
        }
    }
    return NO;
}



- (NSString*)parsetFileType:(FileType)type {
    
    switch (type) {
        case JPEG:
            return @"jpeg";
            break;
        case JPG:
            return @"jpg";
            break;
        case PDF:
            return @"pdf";
            break;
        case TIFF:
            return @"tiff";
            break;
        case TIF:
            return @"tif";
            break;
        case JSON:
            return @"json";
            break;
        case TXT:
            return @"txt";
            break;
        default:
            break;
    }
    return @"";
}
@end
