//
//  LargeImageView.h
//  DemoForLargeImage
//
//  Created by DarkLinden on 12/12/12.
//  Copyright (c) 2012 comcsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) NSString *imgPath;

- (id)initWithFrame:(CGRect)frame;
@end
