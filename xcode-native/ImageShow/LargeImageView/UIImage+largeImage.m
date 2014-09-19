//
//  UIImage+largeImage.m
//  DemoForLargeImage
//
//  Created by DarkLinden on 12/12/12.
//  Copyright (c) 2012 comcsoft. All rights reserved.
//

#import "UIImage+largeImage.h"

@implementation UIImage (largeImage)

+ (CGAffineTransform)transform:(UIImageOrientation)orientation
                          size:(CGSize)size
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationDown:
            transform = CGAffineTransformTranslate(transform, size.width, size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
            transform = CGAffineTransformTranslate(transform, 0, size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

+ (CGRect)rect:(UIImageOrientation)orientation
          rect:(CGRect)rect
{
    switch (orientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
            break;
        default:
            return rect;
            break;
    }
}

+ (UIImage *)imageWithUrl:(NSURL *)url
                   inRect:(CGRect)rect
                     size:(CGSize *)size
                   errMsg:(NSString **)errMsg
{
    NSString *path = url.path;
    return [self imageWithPath:path
                        inRect:rect
                          size:size
                        errMsg:errMsg];
}

+ (UIImage *)imageWithPath:(NSString *)path
                    inRect:(CGRect)rect
                      size:(CGSize *)size
                    errMsg:(NSString **)errMsg
{
    UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
    return [self imageWithImage:sourceImage inRect:rect size:size errMsg:errMsg];
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage
                     inRect:(CGRect)rect
                       size:(CGSize *)size
                     errMsg:(NSString **)errMsg
{
    if(sourceImage == nil) {
        if (errMsg) {
            *errMsg = @"failed to load file";
        }
        return nil;
    }
    
    if (CGRectEqualToRect(rect, CGRectZero)) {
        rect = CGRectMake(0.f, 0.f, sourceImage.size.width * sourceImage.scale, sourceImage.size.height * sourceImage.scale);
    }
    
    CGSize fixSize;
    if (size) {
        fixSize = *size;
    }
    
    if (CGSizeEqualToSize(fixSize, CGSizeZero)) {
        fixSize = [[UIScreen mainScreen] bounds].size;
    }
    
    size_t w = rect.size.width;
    size_t h = rect.size.height;
    
    size_t des_h = fixSize.height;
    size_t des_w = fixSize.height / h * w;
    
    if (des_w <= fixSize.width) {
        //pass
    }
    else {
        des_w = fixSize.width;
        des_h = fixSize.width / w * h;
    }
    
    fixSize = CGSizeMake(des_w, des_h);
    if (size) {
        *size = CGSizeMake(des_w, des_h);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     fixSize.width,
                                                     fixSize.height,
                                                     8,
                                                     fixSize.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        if (errMsg) {
            *errMsg = @"failed to create the output bitmap context!";
        }
        return nil;
    }
    
    CGImageRef sourceTileImageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, [self rect:sourceImage.imageOrientation rect:rect]);
    CGContextConcatCTM(destContext, [self transform:sourceImage.imageOrientation size:fixSize]);
    CGRect destTile = CGRectMake(0.f, 0.f, fixSize.width, fixSize.height);
    destTile = [self rect:sourceImage.imageOrientation rect:destTile];
    CGContextDrawImage(destContext, destTile, sourceTileImageRef);
    CGImageRelease(sourceTileImageRef);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (UIImage *)maskedImageWithImage:(UIImage *)sourceImage
                             path:(CGPathRef)path
{
    CGPathRetain(path);
    if(sourceImage == nil) {
        CGPathRelease(path);
        return nil;
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, sourceImage.size.width * sourceImage.scale, sourceImage.size.height * sourceImage.scale);
    
    CGSize fixSize = sourceImage.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     fixSize.width,
                                                     fixSize.height,
                                                     8,
                                                     fixSize.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if(destContext == NULL) {
        CGPathRelease(path);
        return nil;
    }
    
    CGImageRef sourceTileImageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, [self rect:sourceImage.imageOrientation rect:rect]);
    CGContextConcatCTM(destContext, [self transform:sourceImage.imageOrientation size:fixSize]);
    CGRect destTile = CGRectMake(0.f, 0.f, fixSize.width, fixSize.height);
    destTile = [self rect:sourceImage.imageOrientation rect:destTile];
    
    CGContextAddPath(destContext, path);
    CGContextClip(destContext);
    CGPathRelease(path);
    
    CGContextDrawImage(destContext, destTile, sourceTileImageRef);
    CGImageRelease(sourceTileImageRef);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (CGRect)centerFrameForImage:(UIImage *)image
                         size:(CGSize)size
{
    size_t w_img = image.size.width;
    size_t h_img = image.size.height;
    
    size_t w = size.width;
    size_t h = size.height;
    
    size_t des_h = h_img;
    size_t des_w = (double)h_img / (double)h * (double)w;
    
    if (des_w <= w_img) {
        //pass
    }
    else {
        des_w = w_img;
        des_h = (double)w_img / (double)w * (double)h;
    }
    
    size_t x = (w_img - des_w) / 2;
    size_t y = (h_img - des_h) / 2;
    
    return CGRectMake(x, y, des_w, des_h);
}

+ (UIImage *)centerImageWithImage:(UIImage *)sourceImage
                             size:(CGSize)size
                           errMsg:(NSString *__autoreleasing *)errMsg
{
    CGRect rect = [self centerFrameForImage:sourceImage size:size];
    CGSize _size = size;
    UIImage *image = [self imageWithImage:sourceImage
                                   inRect:rect
                                     size:&_size
                                   errMsg:errMsg];
    return image;
}

+ (UIImage *)centerImageWithPath:(NSString *)sourceImagePath
                            size:(CGSize)size
                          errMsg:(NSString *__autoreleasing *)errMsg
{
    UIImage *sourceImage = [UIImage imageWithContentsOfFile:sourceImagePath];
    return [self centerImageWithImage:sourceImage
                                 size:size
                               errMsg:errMsg];
}

+ (UIImage *)centerImageWithUrl:(NSURL *)url
                            size:(CGSize)size
                          errMsg:(NSString *__autoreleasing *)errMsg
{
    NSString *path = url.path;
    return [self centerImageWithPath:path
                                size:size
                              errMsg:errMsg];
}

+ (UIImage *)cropImagePath:(NSString *)path
                      rect:(CGRect)rect
                    errMsg:(NSString **)errMsg
{
    UIImage *srcImage = [UIImage imageWithContentsOfFile:path];
    return [self cropImage:srcImage rect:rect errMsg:errMsg];
}

+ (UIImage *)cropImage:(UIImage *)image
                  rect:(CGRect)rect
                errMsg:(NSString **)errMsg
{
    CGSize size = rect.size;
    CGRect rectt = CGRectMake(rect.origin.x * image.scale, rect.origin.y * image.scale, rect.size.width * image.scale, rect.size.height * image.scale);
	return [self imageWithImage:image inRect:rectt size:&size errMsg:nil];
}

+ (UIImage *)scaleImagePath:(NSString *)path
                       size:(CGSize)size
                     errMsg:(NSString **)errMsg
{
    UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
    return [self scaleImage:sourceImage size:size errMsg:errMsg];
}

+ (UIImage *)scaleImage:(UIImage *)sourceImage
                   size:(CGSize)size
                 errMsg:(NSString **)errMsg
{
    if(sourceImage == nil) {
        if (errMsg) {
            *errMsg = @"failed to load file";
        }
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     size.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        if (errMsg) {
            *errMsg = @"failed to create the output bitmap context!";
        }
        return nil;
    }
    
    CGContextConcatCTM(destContext, [self transform:sourceImage.imageOrientation size:size]);
    CGRect destTile = CGRectMake(0.f, 0.f, size.width, size.height);
    destTile = [self rect:sourceImage.imageOrientation rect:destTile];
    
    CGContextDrawImage(destContext, destTile, sourceImage.CGImage);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    
    return img;
}

+ (UIImage *)mirroUpDownImageWithImage:(UIImage *)image
{
    CGSize size = image.size;
    size = CGSizeMake(size.width * image.scale, size.height * image.scale);
    UIImage *srcImage = [self imageWithImage:image inRect:CGRectZero size:&size errMsg:nil];
    size = srcImage.size;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     size.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        return nil;
    }
    
    CGContextScaleCTM(destContext, 1, -1);
    CGContextTranslateCTM(destContext, 0, -size.height);
    
    CGRect destTile = CGRectMake(0.f, 0.f, size.width, size.height);
    CGContextDrawImage(destContext, destTile, srcImage.CGImage);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (UIImage *)mirroLeftRightImageWithImage:(UIImage *)image
{
    CGSize size = image.size;
    size = CGSizeMake(size.width * image.scale, size.height * image.scale);
    UIImage *srcImage = [self imageWithImage:image inRect:CGRectZero size:&size errMsg:nil];
    size = srcImage.size;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     size.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        return nil;
    }
    
    CGContextScaleCTM(destContext, -1, 1);
    CGContextTranslateCTM(destContext, -size.width, 0);
    
    CGRect destTile = CGRectMake(0.f, 0.f, size.width, size.height);
    CGContextDrawImage(destContext, destTile, srcImage.CGImage);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (UIImage *)rotateLeftImageWithImage:(UIImage *)image
{
    CGSize size = image.size;
    size = CGSizeMake(size.width * image.scale, size.height * image.scale);
    UIImage *srcImage = [self imageWithImage:image inRect:CGRectZero size:&size errMsg:nil];
    size = CGSizeMake(srcImage.size.height, srcImage.size.width);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     size.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        return nil;
    }
    
    CGContextTranslateCTM(destContext, size.width, 0);
    CGContextRotateCTM(destContext, M_PI_2);
    
    CGRect destTile = CGRectMake(0.f, 0.f, size.height, size.width);
    CGContextDrawImage(destContext, destTile, srcImage.CGImage);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (UIImage *)rotateRightImageWithImage:(UIImage *)image
{
    CGSize size = image.size;
    size = CGSizeMake(size.width * image.scale, size.height * image.scale);
    UIImage *srcImage = [self imageWithImage:image inRect:CGRectZero size:&size errMsg:nil];
    size = CGSizeMake(srcImage.size.height, srcImage.size.width);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef destContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     size.width * 8,
                                                     colorSpace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if( destContext == NULL ) {
        return nil;
    }
    
    CGContextTranslateCTM(destContext, 0, size.height);
    CGContextRotateCTM(destContext, -M_PI_2);
    
    CGRect destTile = CGRectMake(0.f, 0.f, size.height, size.width);
    CGContextDrawImage(destContext, destTile, srcImage.CGImage);
    
    CGImageRef destImage = CGBitmapContextCreateImage(destContext);
    CGContextRelease(destContext);
    
    UIImage *img = [UIImage imageWithCGImage:destImage];
    CGImageRelease(destImage);
    return img;
}

+ (void)test_save_image:(UIImage *)img
{
    NSData *data = UIImagePNGRepresentation(img);
    
    NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUInteger i = 1;
    NSString *path_des = [NSString stringWithFormat:@"%@/%lu.png", path_doc, (unsigned long)i];
    
    while ([[NSFileManager defaultManager] fileExistsAtPath:path_des]) {
        i++;
        path_des = [NSString stringWithFormat:@"%@/%lu.png", path_doc, (unsigned long)i];
    }
    
    [data writeToFile:path_des atomically:YES];
}

@end
