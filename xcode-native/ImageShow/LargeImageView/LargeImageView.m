//
//  LargeImageView.m
//  DemoForLargeImage
//
//  Created by DarkLinden on 12/12/12.
//  Copyright (c) 2012 comcsoft. All rights reserved.
//

#import "LargeImageView.h"
#import "UIImage+largeImage.h"

@interface LargeImageView ()
@property (strong, nonatomic) UIImageView               *pVimg_content;
@property (strong, nonatomic) UIView                    *pV_loading;
@property (strong, nonatomic) UIActivityIndicatorView   *pV_act;
@property (strong, nonatomic) UILongPressGestureRecognizer   *ge;
@end

@implementation LargeImageView
@synthesize imgPath = _imgPath;

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
        self.pVimg_content = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
        _pVimg_content.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.pVimg_content];
        
        self.ge = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchDown:)];
        _ge.minimumPressDuration = 0.2;
        [self addGestureRecognizer:_ge];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pVimg_content;
}

- (void)addLoading
{
    if (self.pV_act) {
        [self.pV_act removeFromSuperview];
        self.pV_act = nil;
    }
    
    if (self.pV_loading) {
        [self.pV_loading removeFromSuperview];
        self.pV_loading = nil;
    }
    
    [self setZoomScale:1.f];
    self.pV_loading = [[UIView alloc] initWithFrame:self.bounds];
    self.pV_loading.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
    self.pV_act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.pV_act startAnimating];
    self.pV_act.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    [self.pV_loading addSubview:self.pV_act];
    
    [self addSubview:self.pV_loading];
}

- (void)removeLoading
{
    [self.pV_act removeFromSuperview];
    self.pV_act = nil;
    [self.pV_loading removeFromSuperview];
    self.pV_loading = nil;
}

- (NSString *)imgPath
{
    return _imgPath;
}

- (void)setImgPath:(NSString *)imgPath
{
    _imgPath = imgPath;
    [self addLoading];
    [self performSelectorInBackground:@selector(setupImage) withObject:nil];
}

- (void)didSetupImage:(NSDictionary *)dict
{
    if (self) {
        if (self.superview) {
            UIImage *img = [dict objectForKey:@"img"];
            CGSize size = [[dict objectForKey:@"size"] CGSizeValue];
            
            self.pVimg_content.image = img;
            CGRect frame = self.pVimg_content.frame;
            frame.size = size;
            self.pVimg_content.frame = frame;
            self.pVimg_content.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            [self removeLoading];
        }
    }
}

- (void)setupImage
{
    CGSize size = self.pVimg_content.frame.size;
    UIImage *img = [UIImage imageWithPath:self.imgPath
                                         inRect:CGRectZero
                                           size:&size
                                         errMsg:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          img, @"img",
                          [NSValue valueWithCGSize:size], @"size", nil];
    
    if (self) {
        if (self.superview) {
            [self performSelectorOnMainThread:@selector(didSetupImage:) withObject:dict waitUntilDone:NO];
        }
    }
}

- (void)resetOffset
{
    CGFloat w = self.pVimg_content.frame.size.width > self.bounds.size.width ? self.pVimg_content.frame.size.width : self.bounds.size.width;
    CGFloat h = self.pVimg_content.frame.size.height > self.bounds.size.height ? self.pVimg_content.frame.size.height : self.bounds.size.height;
    [self setContentSize:CGSizeMake(w, h)];
    [self.pVimg_content setCenter:CGPointMake(self.contentSize.width / 2.f, self.contentSize.height / 2.f)];
}

- (CGRect)IntegralRectInFrame:(CGRect)frame
{
    size_t w = self.pVimg_content.image.size.width;
    size_t h = self.pVimg_content.image.size.height;
    
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
        self.pVimg_content.frame = [self IntegralRectInFrame:frame];
        [self resetOffset];
        
        if (self.pV_loading) {
            self.pV_loading.frame = self.bounds;
        }
        if (self.pV_act) {
            self.pV_act.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
        }
    }];
}

- (void)removeFromSuperview
{
    //set zoom to 1.f to reduce memory alloc when release
    [self setZoomScale:1.f];
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

- (void)touchDown:(id)sender
{
    [self removeFromSuperview];
}

@end
