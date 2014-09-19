//
//  CoverImagerView.h
//  DemoForLargeImage
//
//  Created by darklinden on 12/12/12.
//  Copyright (c) 2012 darklinden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverImagerView : UIScrollView <UIScrollViewDelegate>
@property (strong, nonatomic) UIImage   *image;
@property (assign, nonatomic) CGRect    fromRect;

+ (void)showImage:(UIImage *)image fromRect:(CGRect)rect;

@end
