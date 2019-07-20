//
//  ImageManager.h
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/31.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileUnit.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,FileType) {
    NONE,
    PNG,
    JPEG,
    JPG,
    TIFF,
    TXT,
    PDF,
    JSON,
};

@interface UIImage (Enhance)

+ (NSArray<NSString*>*)getImagePathsWithContetnsFolder:(NSString*)folderPath type:(NSString*)type;
- (BOOL)saveJPEGtoPath:(NSString*)outputPath withQuality:(CGFloat)quality;
- (BOOL)savePNGtoPath:(NSString*)outputPath;
- (NSString*)toBase64DataStringWithQuality:(CGFloat)quality;

@end




@interface ImageManager : NSObject

//轉檔

/**
 PDF轉TIFF
 
 @param pdfPath PDF路徑
 @param outputPath TIFF 輸出路徑
 @return TIFF 輸出路徑
 */
- (NSString*)convertPDFtoTIFFwithContenOfFile:(NSString*)pdfPath outputPath:(NSString*)outputPath;


/**
 PDF轉JPG
 
 @param fileUnit PDF路徑
 @param outputPath JPG 輸出路徑
 @return JPG 輸出路徑
 */
- (BOOL)convertPDFtoJPGwithContenOfFile:(FileUnit*)fileUnit saveTofolder:(NSString*)outputPath;

/**
 PDF轉JPG
 
 @param fileUnit 檔案
 @param outputPath 輸出路徑
 @param pageRagne 切割範圍
 @return 是否完成
 */
- (BOOL)convertPDFtoJPGwithContenOfFile:(FileUnit*)fileUnit saveTofolder:(NSString*)outputPath page:(NSRange)pageRagne;


//JPG to TIFF

/**
 轉檔 單一張 jpg To TIFF
 
 @param image jpg
 @param outputPath tiff輸出路徑
 @return 轉檔成功？
 */
- (BOOL)convertJPGtoTIFFwithImage:(UIImage*)image outputPath:(NSString*)outputPath;


/**
 轉檔
 
 @param files 檔案清單
 @param outputPath 輸出路徑
 @return 是否轉檔成功
 */
- (BOOL)convertJPGtoTIFFwithFiles:(NSArray<FileUnit*>*)files outputFolderPath:(NSString*)outputPath;


/**
 folder path 下 JPG to TIFF
 
 @param folderPath folderPath
 @param outpath outpath
 @return 是否轉檔完成
 */
- (BOOL)convertJPGtoTIFFwithContentFolder:(NSString*)folderPath outputFolderPath:(NSString*)outpath;


/**
 圖片轉灰階
 
 @param iamge 來源圖片
 @return 灰階圖片
 */
- (UIImage *)convertImageToGrayScale:(UIImage*)iamge;
//特定目錄假圖片全部轉灰階





//FileManager
- (NSArray<FileUnit*>*)getFilePathsFromContentFolder:(NSString*)folderPath;
- (NSArray<FileUnit*> *)getFileInfoFromContentOfFolerPath:(NSString*)forderPath fileType:(FileType)type;

@end


NS_ASSUME_NONNULL_END
