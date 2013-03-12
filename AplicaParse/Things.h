//
//  Things.h
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Things : NSObject {
    NSString *name;
    NSString *price;
    NSString *text;
    NSString *photo;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSMutableArray *files;
@property (nonatomic, retain) NSMutableArray *filesBig;

@end
