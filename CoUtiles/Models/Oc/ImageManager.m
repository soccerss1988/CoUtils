//
//  ImageManager.m
//  DevEnhance
//
//  Created by YJ Huang on 2019/3/31.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

#import "ImageManager.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

@implementation ImageManager

- (instancetype)init {
    if([super init])
    {
    }
    return self;
}


- (NSString*)convertPDFtoTIFFwithContenOfFile:(NSString*)pdfPath outputPath:(NSString*)outputPath
{
    //    //convert to jpg
    //    NSMutableArray *fileList = [self convertPDFintoJPGfileswithContentPath:pdfPath scale:0];
    //
    //    //save jpg into disk
    //    [self saveJPGfileTo:self.jpgTempPath formFiles:fileList];
    //
    //    //load jpg from tempfolder
    //    NSMutableArray * jpgfiles = [self loadJPGfileFromTempPath];
    //
    //    //convert jpg into tiff
    //    [self convetJPGintoTIFFwithImgs:jpgfiles outputPath:outputPath];
    //
    //    //remvoe jpg tmep
    //    [self removePath:self.jpgTempPath];
    //    return outputPath;
    return @"";
}


- (BOOL)convertPDFtoJPGwithContenOfFile:(FileUnit*)fileUnit saveTofolder:(NSString*)outputPath
{
    //convert to jpg
    NSMutableArray *fileList = [self convertPDFintoJPGfileswithContentPath:fileUnit.stringPath scale:0];
    
    //save jpg into disk
    if ([self saveJPGfileTo:outputPath formFiles:fileList]) {
        return YES;
    }
    return NO;
}


- (BOOL)convertPDFtoJPGwithContenOfFile:(FileUnit*)fileUnit saveTofolder:(NSString*)outputPath page:(NSRange)pageRagne {
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileUnit.stringPath]) {
        return NO;
    }
    
    NSMutableArray *fileList = [self convertPDFintoJPGfileswithContentPath:fileUnit.stringPath scale:0];
    
    NSInteger startPage = pageRagne.location;//0
    NSInteger totalPages  = pageRagne.length;//5
    NSMutableArray *cutPDFList = [[NSMutableArray alloc]init];
    
    if(startPage>0) {
        startPage = startPage - 1;
    }
    
    for (NSInteger page = startPage  ; page < (startPage + totalPages); page += 1) {
        [cutPDFList addObject:[fileList objectAtIndex:page]];
    }
    
    if ([self saveJPGfileTo:outputPath formFiles:cutPDFList]) {
        return YES;
    }
    
    NSArray * outputFileList = [self getFilePathsFromContentFolder:outputPath];
    if(outputFileList.count == totalPages) {
        return YES;
    }
    return NO;
}

#pragma mark PDF into image
- (NSMutableArray<UIImage*>*)convertPDFintoJPGfileswithContentPath:(NSString*)pdfPath scale:(CGFloat)scale
{
    NSString *pdfName = pdfPath.lastPathComponent;
    
    if(!pdfName || [pdfName length] == 0)
        return nil;
    
    //NSURL *imageURL = [[NSBundle mainBundle] URLForResource:pdfName withExtension:@"pdf"];
    
    NSURL *imageURL = [NSURL fileURLWithPath:pdfPath];
    
    if(!imageURL) {
        NSLog(@"Couldn't find a PDF document named: %@", pdfName);
        return nil;
    }
    
    // Load the pdf
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)imageURL);
    
    if(!pdfDocument) {
        NSLog(@"Couldn't load the PDF document named: %@", pdfName);
        return nil;
    }
    
    size_t count = CGPDFDocumentGetNumberOfPages(pdfDocument);
    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
    
    for (int page = 1;page <= count;page++){
        
        CGPDFPageRef firstPage = CGPDFDocumentGetPage(pdfDocument, page);
        if(!firstPage) {
            NSLog(@"Couldn't find any pages for the PDF document named: %@", pdfName);
            CGPDFDocumentRelease(pdfDocument);
            return nil;
        }
        
        CGSize imageSize = CGPDFPageGetBoxRect(firstPage, kCGPDFCropBox).size;
        
        // Scale the image by the
        if(scale < 0.00001f)
            scale = [[UIScreen mainScreen] scale];
        
        scale =2;
        
        imageSize.width *= scale;
        imageSize.height *= scale;
        
        
        // Setup a graphics context to draw into
        UIGraphicsBeginImageContext(imageSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Flip the context so that the image draws the right way up
        CGContextTranslateCTM(context, 0, imageSize.height);
        CGContextScaleCTM(context, scale, -scale);
        
        // Draw the pdf into the context
        CGContextDrawPDFPage(context, firstPage);
        
        // Create an image from the context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [imageArr addObject:image];
    }
    CGPDFDocumentRelease(pdfDocument);
    
    return imageArr;
}


- (BOOL)convertJPGtoTIFFwithContentFolder:(NSString*)folderPath outputFolderPath:(NSString*)outpath {
    
    NSArray *jpgPaths = [UIImage getImagePathsWithContetnsFolder:folderPath type:@"jpg"];
    
    if(jpgPaths.count > 0) {
        
        for (int index = 0 ; index < jpgPaths.count ; index += 1) {
            
            NSString *currentPath = jpgPaths[index];
            NSString *fileName =  [currentPath.lastPathComponent.stringByDeletingPathExtension stringByAppendingString:@".tif"];
            
            //out put setting
            NSURL *outputFilePath = [NSURL URLWithString:[folderPath stringByAppendingPathComponent:fileName]];
            NSData *data = [NSData dataWithContentsOfFile:currentPath];
            UIImage *currentImg = [[UIImage alloc]initWithData:data];
            WriteCCITTTiffWithCGImage_URL_(currentImg.CGImage, (__bridge CFURLRef)outputFilePath);
        }
    }
    return YES;
}

- (BOOL)convertJPGtoTIFFwithFiles:(NSArray<FileUnit*>*)files outputFolderPath:(NSString*)outputPath {
    
    /*check folder and create
     */
    [self createPath:outputPath removeExists:YES];
    
    for (FileUnit * fileUni in files) {
        NSString *curretName = [NSString stringWithFormat:@"%@.tif",fileUni.nameWithoutExten];
        NSString * tiffFilePath = [outputPath stringByAppendingPathComponent:curretName];
        
        [self convertJPGtoTIFFContentOfFile:fileUni.stringPath outputPath:tiffFilePath];
    }
    NSArray *tiffArry = [self getFileInfoFromContentOfFolerPath:outputPath fileType:TIFF];
    if( (tiffArry.count > 0) && (tiffArry.count == files.count) ) {
        return YES;
    }
    return NO;
}

- (BOOL)convertJPGtoTIFFwithImage:(UIImage*)image outputPath:(NSString*)outputPath {
    
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    WriteCCITTTiffWithCGImage_URL_(image.CGImage,  (__bridge CFURLRef)outputURL);
    if([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        return YES;
    }
    return NO;
}


/**
 轉檔 單一張 jpg To TIFF
 
 @param filePath jpg圖片路徑
 @param outputPath tiff輸出路徑
 @return 轉檔成功？
 */
- (BOOL)convertJPGtoTIFFContentOfFile:(NSString*)filePath outputPath:(NSString*)outputPath {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    if([self convertJPGtoTIFFwithImage:image outputPath:outputPath]) {
        return YES;
    }
    return NO;
}














//影像處理 Private method
- (UIImage *)convertImageToGrayScale:(UIImage*)iamge {
    
    CGSize size =iamge.size;
    
    int width =size.width;
    int height =size.height;
    
    //像素将画在这个数组
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    //清空像素数组
    memset(pixels, 0, width*height*sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用 pixels 创建一个 context
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height),iamge.CGImage);
    
    int tt =1;
    CGFloat intensity;
    int bw;
    
    for (int y = 0; y <height; y++) {
        for (int x =0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 4.55/ 255.;
            
            bw = intensity > 0.45?255:0;
            
            rgbaPixel[tt] = bw;
            rgbaPixel[tt + 1] = bw;
            rgbaPixel[tt + 2] = bw;
            
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}


- (void)changeDPI:(NSURL*)tiffpath page:(int)page{
    
    NSData *tiffData=[NSData dataWithContentsOfURL:tiffpath];
    NSString *newtiffPath=tiffpath.absoluteString;
    newtiffPath=[newtiffPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    [tiffData writeToFile:newtiffPath atomically:YES];
    
}


static void WriteCCITTTiffWithCGImage_URL_(CGImageRef im, CFURLRef url) {
    // produce grayscale image
    
    CGImageRef grayscaleImage;
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);//建立色彩空間
        
        CGContextRef bitmapCtx = CGBitmapContextCreate(NULL, CGImageGetWidth(im), CGImageGetHeight(im),8,0, colorSpace, kCGImageAlphaNone);
        
        CGContextDrawImage(bitmapCtx, CGRectMake(0,0,CGImageGetWidth(im), CGImageGetHeight(im)),im);
        grayscaleImage = CGBitmapContextCreateImage(bitmapCtx);
        
        
        CFRelease(bitmapCtx);
        CFRelease(colorSpace);
    }
    
    // generate options for ImageIO. Man this sucks in C.  //SCR-63570
    CFMutableDictionaryRef options = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    {
        {
            CFMutableDictionaryRef tiffOptions = CFDictionaryCreateMutable(kCFAllocatorDefault,1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            int fourInt = 4;
            
            //2=負片  3=CCITT fax3  4=CCITT fax4 5=LZW  6=LZW  7 8
            
            CFNumberRef fourNumber = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fourInt);
            CFDictionarySetValue(tiffOptions, kCGImagePropertyTIFFCompression, fourNumber);
            CFRelease(fourNumber);
            
            CFDictionarySetValue(options, kCGImagePropertyTIFFDictionary, tiffOptions);
            
            CFDictionarySetValue(options, kCGImagePropertyDPIHeight,
                                 (__bridge const void *)([NSNumber numberWithInteger:200]));
            CFDictionarySetValue(options, kCGImagePropertyDPIWidth,
                                 (__bridge const void *)([NSNumber numberWithInteger:200]));
            CFRelease(tiffOptions);
        }
        
        {
            
            int oneInt = 1;
            CFNumberRef oneNumber = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &oneInt);
            
            CFDictionarySetValue(options, kCGImagePropertyDepth, oneNumber);
            
            CFRelease(oneNumber);
        }
    }
    
    // write file
    CGImageDestinationRef idst = CGImageDestinationCreateWithURL(url, kUTTypeTIFF, 1, NULL);
    
    CGImageDestinationAddImage(idst,grayscaleImage, options);
    CGImageDestinationFinalize(idst);
    
    // clean up
    CFRelease(idst);
    CFRelease(options);
    CFRelease(grayscaleImage);
    
    NSLog(@"%@",url);
}


//MARK: file operation

- (NSArray<UIImage*>*)loadImagesFromContertOfFolerPath:(NSString*)forderPath {
    
    NSMutableArray *imgs = [[NSMutableArray alloc]init];
    NSArray *imgPaths = [self getFilePathsFromContentFolder:forderPath];
    
    for (NSURL *path in imgPaths ) {
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:path.absoluteString];
        if(image) {
            [imgs addObject:image];
        }
    }
    return imgs;
}


- (BOOL)saveJPGfileTo:(NSString*)outputPath formFiles:(NSMutableArray*)fileList {
    
    [self createPath:outputPath removeExists:YES];
    
    if(fileList.count >0) {
        
        for (int index = 0; index<fileList.count; index += 1){
            NSData *imageData = UIImageJPEGRepresentation(fileList[index], 1.0);
            NSString *imageNameFS = [NSString stringWithFormat:@"jpg_%i.jpg",index + 1];
            [imageData writeToFile:[outputPath stringByAppendingPathComponent:imageNameFS] atomically:YES];
        }
        
        if ([self getFilePathsFromContentFolder:outputPath].count == fileList.count) {
            return YES;
        }
    }
    
    return NO;
}



//MARK: NSFileManager

//取得特定路徑下 的檔案清單 可選擇要獲取的類型 TEST OK
- (NSArray<FileUnit*> *)getFileInfoFromContentOfFolerPath:(NSString*)forderPath fileType:(FileType)type {
    
    NSArray <FileUnit*> *filePaths = [self getFilePathsFromContentFolder:forderPath];
    NSString *filterRule = [NSString stringWithFormat:@"name CONTAINS '%@'",[self parsetFileType:type]];
    NSPredicate *prdicate = [NSPredicate predicateWithFormat:filterRule];
    NSArray *result = [filePaths filteredArrayUsingPredicate:prdicate];
    return result;
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


//TEST OK
- (NSArray<FileUnit*>*)getFilePathsFromContentFolder:(NSString*)folderPath {
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:folderPath ] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    for (NSURL *fileUrl in fileList) {
        FileUnit *fileUni = [[FileUnit alloc]initWithContentsOfUrl:fileUrl];
        [result addObject:fileUni];
    }
    return result;
}


- (BOOL)createPath:(NSString*)path removeExists:(BOOL)needRemoe {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (needRemoe) {
        //remove
        [fm removeItemAtPath:path error:nil];
    }
    
    BOOL isPathEsist = [fm fileExistsAtPath:path];
    if(isPathEsist)
    {
        NSLog(@"path Existed = %@",path);
        return YES;
    }
    else
    {
        
        if([fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"path Careate successful =%@",path);
            return YES;
        }
        return NO;
    }
}


- (BOOL)removePath:(NSString*)path {
    
    NSFileManager *fm=[NSFileManager defaultManager];
    //要先檢查檔案是否有存在
    if([fm fileExistsAtPath:path]){
        //如果有先刪掉
        [fm removeItemAtPath:path error:nil];
    }
    
    if(![fm fileExistsAtPath:path]){
        return YES;
    }
    return NO;
}
@end
