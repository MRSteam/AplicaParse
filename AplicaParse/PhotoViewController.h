//
//  PhotoViewController.h
//  AplicaParse
//
//  Created by Stas-PC on 09.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray *images;
}

@property (nonatomic, strong) UIImageView *imageView;
- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
@property (nonatomic, retain) NSMutableArray *images;


@end
