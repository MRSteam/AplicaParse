//
//  PhotoViewController.m
//  AplicaParse
//
//  Created by Stas-PC on 09.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface PhotoViewController ()
{
    UIScrollView *scrollview;
}
@end

@implementation PhotoViewController
@synthesize images;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = scrollview.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale;
    if (scrollview.zoomScale==scrollview.maximumZoomScale)
    {
        newZoomScale = scrollview.minimumZoomScale;
    }
    else
    {
        newZoomScale = scrollview.maximumZoomScale;
    }
    
    CGSize scrollViewSize = scrollview.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [scrollview zoomToRect:rectToZoomTo animated:YES];
}

- (void)viewDidLoad
{
     [super viewDidLoad];
	 // Do any additional setup after loading the view.
    
     scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     
     scrollview.frame = CGRectMake(0, 0, 320, 420);
     scrollview.contentSize = self.imageView.frame.size;
     [scrollview setContentMode:UIViewContentModeScaleAspectFit];
     [scrollview sizeToFit];
     scrollview.delegate=self;
     [scrollview setShowsHorizontalScrollIndicator:NO];
     [scrollview setShowsVerticalScrollIndicator:NO];
     [self.view addSubview:scrollview];
     
     UIImage *image = [UIImage imageWithData:[images objectAtIndex:arc4random() % [images count]]];
     self.imageView = [[UIImageView alloc] initWithImage:image];
     self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
     [scrollview addSubview:self.imageView];
     
     scrollview.contentSize = CGSizeMake(image.size.width, image.size.width);
     
     UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
     doubleTapRecognizer.numberOfTapsRequired = 2;
     doubleTapRecognizer.numberOfTouchesRequired = 1;
     [scrollview addGestureRecognizer:doubleTapRecognizer];    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return [[scrollview subviews] objectAtIndex:0];
}

-(float) findZoomScale {
    float widthRatio = self.view.bounds.size.width / self.imageView.image.size.width;
    float heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
    float ratio;
    if (widthRatio > heightRatio) ratio = widthRatio;
    else ratio = heightRatio;
    return ratio;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    scrollview.zoomScale = 1;

    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //landscape view
        scrollview.contentSize = CGSizeMake(480, 270);
        scrollview.frame = CGRectMake(0, 0, 480, 270);
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || toInterfaceOrientation == UIInterfaceOrientationPortrait)
    { 
        //portrait view
        scrollview.contentSize = self.imageView.frame.size;
        scrollview.frame = CGRectMake(0, 0, 320, 420);
    }
    
    scrollview.zoomScale = [self findZoomScale];
    [self centerScrollViewContents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect scrollViewFrame = scrollview.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / scrollview.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / scrollview.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    scrollview.minimumZoomScale = minScale;

    scrollview.maximumZoomScale = 1.0f;
    scrollview.zoomScale = minScale;

    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
