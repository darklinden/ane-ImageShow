//
//  CoverImagerView.m
//  DemoForLargeImage
//
//  Created by DarkLinden on 12/12/12.
//  Copyright (c) 2012 comcsoft. All rights reserved.
//

#import "CoverImagerView.h"
#import "UIImage+largeImage.h"

@interface CoverImagerView ()
@property (strong, nonatomic) UIImageView               *contentImageView;
@property (strong, nonatomic) UIImageView               *animateImageView;
@property (strong, nonatomic) UITapGestureRecognizer    *tap;
@end

@implementation CoverImagerView

+ (void)showImage:(UIImage *)image fromRect:(CGRect)rect
{
    UIView *view = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    CoverImagerView *iv = [[CoverImagerView alloc] initWithFrame:view.bounds];
    [view addSubview:iv];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self setDelegate:self];
        [self setBouncesZoom:YES];
        [self setMaximumZoomScale:4.f];
        [self setMinimumZoomScale:1.f];
        [self setShowsHorizontalScrollIndicator:FALSE];
        [self setShowsVerticalScrollIndicator:FALSE];
        [self setContentMode:UIViewContentModeCenter];
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
        _contentImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.contentImageView];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:_tap];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self animateShow];
}

- (void)animateShow
{
    CGRect endRect = CGRectMake((self.frame.size.width - _image.size.width) / 2.f,
                                (self.frame.size.height - _image.size.height) / 2.f,
                                _image.size.width,
                                _image.size.height);
    
    self.contentImageView.image = _image;
    self.contentImageView.frame = _fromRect;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentImageView.frame = endRect;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateHide
{
    [self setZoomScale:1.f];
    [UIView animateWithDuration:0.2 animations:^{
        self.contentImageView.frame = _fromRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentImageView;
}

- (void)resetOffset
{
    CGFloat w = self.contentImageView.frame.size.width > self.bounds.size.width ? self.contentImageView.frame.size.width : self.bounds.size.width;
    CGFloat h = self.contentImageView.frame.size.height > self.bounds.size.height ? self.contentImageView.frame.size.height : self.bounds.size.height;
    [self setContentSize:CGSizeMake(w, h)];
    [self.contentImageView setCenter:CGPointMake(self.contentSize.width / 2.f, self.contentSize.height / 2.f)];
}

- (CGRect)IntegralRectInFrame:(CGRect)frame
{
    size_t w = self.contentImageView.image.size.width;
    size_t h = self.contentImageView.image.size.height;
    
    size_t des_h = frame.size.height;
    size_t des_w = frame.size.height / h * w;
    
    if (des_w <= w) {
        //pass
    }
    else {
        des_w = frame.size.width;
        des_h = frame.size.width / w * h;
    }
    
    return CGRectMake(0.f, 0.f, des_w, des_h);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [UIView animateWithDuration:0.2f animations:^{
        [self setZoomScale:1.f];
        self.contentImageView.frame = [self IntegralRectInFrame:frame];
        [self resetOffset];
    }];
}

- (void)removeFromSuperview
{
    //set zoom to 1.f to reduce memory alloc when release
    [super removeFromSuperview];
}

- (void)dealloc
{
    //set zoom to 1.f to reduce memory alloc when release
    [self setZoomScale:1.f];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self resetOffset];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self resetOffset];
}

- (void)taped:(id)sender
{
    [self animateHide];
}

@end
