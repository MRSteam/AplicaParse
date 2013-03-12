//
//  mainCell.m
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import "mainCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation mainCell
@synthesize nameLabel,textLabel,priceLabel,numPhotoLabel,photoImageView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        UIColor *bgColor = [UIColor colorWithRed:0.9686 green:0.9686 blue:0.9686 alpha:1];
        UIColor *textColor = [UIColor colorWithRed:0.1843 green:0.2824 blue:0.5216 alpha:1];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        nameLabel.textAlignment = UITextAlignmentLeft;
        //nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.numberOfLines = 0;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.backgroundColor = bgColor;
        nameLabel.adjustsFontSizeToFitWidth = NO;
        nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
        
        textLabel = [[UILabel alloc]init];
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = bgColor;
        
        priceLabel = [[UILabel alloc]init];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.lineBreakMode = UILineBreakModeWordWrap;
        priceLabel.numberOfLines = 0;
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.backgroundColor = bgColor;
        
        numPhotoLabel = [[UILabel alloc]init];
        numPhotoLabel.textAlignment = UITextAlignmentLeft;
        numPhotoLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        numPhotoLabel.textAlignment = UITextAlignmentCenter;
        numPhotoLabel.lineBreakMode = UILineBreakModeWordWrap;
        numPhotoLabel.numberOfLines = 0;
        numPhotoLabel.textColor = [UIColor whiteColor];
        numPhotoLabel.backgroundColor = [UIColor blackColor];
        numPhotoLabel.layer.cornerRadius = 8;
        numPhotoLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        numPhotoLabel.layer.borderWidth = 1.0;

        photoImageView = [[UIImageView alloc] init];
        
        
        self.contentView.backgroundColor = bgColor;
        
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:photoImageView];
        [self.contentView addSubview:numPhotoLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    /*
    priceLabel.layer.borderColor = [UIColor blackColor].CGColor;
    priceLabel.layer.borderWidth = 1.0;
    nameLabel.layer.borderColor = [UIColor blackColor].CGColor;
    nameLabel.layer.borderWidth = 1.0;
    textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    textLabel.layer.borderWidth = 1.0;
    photoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    photoImageView.layer.borderWidth = 1.0;
    numPhotoLabel.layer.borderColor = [UIColor blackColor].CGColor;
    numPhotoLabel.layer.borderWidth = 1.0;
    */
    frame= CGRectMake(10,          5,          100,  20);
    priceLabel.frame = frame;
    
    frame= CGRectMake(10+100+10,   5,          180,  40);
    nameLabel.frame = frame;
    
    frame= CGRectMake(10+100+10,   5+35+5,    180,  60);
    textLabel.frame = frame;
    
    frame= CGRectMake(10,          5+20,    103,  77);
    photoImageView.frame = frame;
    
    frame= CGRectMake(10+35+5,       20+30+30, 60,   20);
    numPhotoLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
