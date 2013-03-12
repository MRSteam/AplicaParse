//
//  XMLParser.h
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Things;

@interface XMLParser : NSObject {
    // an ad hoc string to hold element value
    NSMutableString *currentElementValue;
    int countBody;
    // user object
    Things *thing;
    // array of user objects
    NSMutableArray *things;
    
    NSMutableArray *files;
    NSMutableArray *filesBig;
    NSString *searchLastFile;
}

@property (nonatomic, retain) Things *thing;
@property (nonatomic, retain) NSMutableArray *things;

- (XMLParser *) initXMLParser;

@end
