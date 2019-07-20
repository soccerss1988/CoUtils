//
//  NSFileManager+Enhance.h
//  DevTools
//
//  Created by YJ Huang on 2019/3/19.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,FileType) {
    TXT,
    JPG,
    JPEG,
    PDF,
    TIF,
    TIFF,
    JSON
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^ __nullable errorhandler)( NSError * _Nullable error, BOOL successful);

@interface NSFileManager (Enhance)
- (NSString*)documentDirectory;
- (NSString*)libraryDirectory;
- (NSString*)cachesDirectory;

//file operation
- (void)moveItemFromPath:(NSString*)oraginPath toPath:(NSString*)destinationPath errorHandler:(errorhandler)handler;
- (NSArray*)getFileInfoFromContentOfFolerPath:(NSString*)forderPath fileType:(FileType)type;
- (NSArray*)getFilePathsFromContentFolder:(NSString*)folderPath;
@end

NS_ASSUME_NONNULL_END
