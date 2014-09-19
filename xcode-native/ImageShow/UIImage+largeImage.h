//
//  UIImage+largeImage.h
//  DemoForLargeImage
//
//  Created by darkLinden on 12/12/12.
//  Copyright (c) 2012 darkLinden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (largeImage)

+ (UIImage *)imageWithUrl:(NSURL *)url
                   inRect:(CGRect)rect
                     size:(CGSize *)size
                   errMsg:(NSString **)errMsg;

+ (UIImage *)imageWithPath:(NSString *)path
                    inRect:(CGRect)rect
                      size:(CGSize *)size
                    errMsg:(NSString **)errMsg;

+ (UIImage *)imageWithImage:(UIImage *)sourceImage
                     inRect:(CGRect)rect
                       size:(CGSize *)size
                     errMsg:(NSString **)errMsg;

+ (UIImage *)maskedImageWithImage:(UIImage *)sourceImage
                             path:(CGPathRef)path;

+ (UIImage *)centerImageWithImage:(UIImage *)sourceImage
                             size:(CGSize)size
                           errMsg:(NSString **)errMsg;

+ (UIImage *)centerImageWithPath:(NSString *)sourceImagePath
                            size:(CGSize)size
                          errMsg:(NSString **)errMsg;

+ (UIImage *)centerImageWithUrl:(NSURL *)url
                           size:(CGSize)size
                         errMsg:(NSString **)errMsg;

+ (UIImage *)cropImagePath:(NSString *)path
                      rect:(CGRect)rect
                    errMsg:(NSString **)errMsg;

+ (UIImage *)cropImage:(UIImage *)image
                  rect:(CGRect)rect
                errMsg:(NSString **)errMsg;

+ (UIImage *)scaleImage:(UIImage *)sourceImage
                   size:(CGSize)size
                 errMsg:(NSString **)errMsg;

+ (UIImage *)scaleImagePath:(NSString *)path
                       size:(CGSize)size
                     errMsg:(NSString **)errMsg;

+ (UIImage *)mirroUpDownImageWithImage:(UIImage *)image;

+ (UIImage *)mirroLeftRightImageWithImage:(UIImage *)image;

+ (UIImage *)rotateLeftImageWithImage:(UIImage *)image;

+ (UIImage *)rotateRightImageWithImage:(UIImage *)image;

+ (void)test_save_image:(UIImage *)img;

@end
