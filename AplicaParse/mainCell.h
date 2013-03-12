//
//  mainCell.h
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainCell : UITableViewCell {
    UILabel *nameLabel, *priceLabel, *textLabel, *numPhotoLabel;
    UIImageView *photoImageView;
}

@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UILabel *numPhotoLabel;
@property(nonatomic,retain)UIImageView *photoImageView;

@end

