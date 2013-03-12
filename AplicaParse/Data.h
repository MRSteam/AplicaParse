//
//  Data.h
//  AplicaParse
//
//  Created by Stas-PC on 10.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Data : NSManagedObject

@property (nonatomic, retain) NSData * files;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * filesBig;

@end
