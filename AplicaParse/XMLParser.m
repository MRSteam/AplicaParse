//
//  XMLParser.m
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import "XMLParser.h"

#import "XMLParser.h"
#import "Things.h"

@implementation XMLParser
@synthesize thing, things;

- (XMLParser *) initXMLParser {
    //[super init];
    // init array of things objects
    things = [[NSMutableArray alloc] init];
    files = [[NSMutableArray alloc] init];
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"body"]) {
        //NSLog(@"body element found");
        thing = [[Things alloc] init];
        files = [[NSMutableArray alloc] init];
        filesBig = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"image"]) {
        if (([[attributeDict valueForKey:@"height"] isEqualToString:@"77"]) && ([[attributeDict valueForKey:@"width"] isEqualToString:@"103"]))
        {
            //small image
            //NSLog(@"url %@",[attributeDict valueForKey:@"url"]);
            [files addObject:[attributeDict valueForKey:@"url"]];
        }
        //last image - big size
        searchLastFile = [attributeDict valueForKey:@"url"];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
        
        [currentElementValue setString:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    }
    //NSLog(@"Processing value for : %@ %d", string, [currentElementValue length]);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    //format string from xml
    NSString *theString = currentElementValue;
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEnterStrings = [NSPredicate predicateWithFormat:@"SELF != '\\n'"];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [theString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEnterStrings];
    filteredArray = [filteredArray filteredArrayUsingPredicate:noEmptyStrings];
    theString = [filteredArray componentsJoinedByString:@" "];
    
    if ([elementName isEqualToString:@"name"]) {
        thing.name = theString;
    }
    
    if ([elementName isEqualToString:@"text"]) {
        thing.text = theString;
    }
    
    if ([elementName isEqualToString:@"photo"]) {
        thing.photo = theString;
    }
    
    if ([elementName isEqualToString:@"value"]) {
        thing.price = theString;
    }
    
    if ([elementName isEqualToString:@"images"]) {
        [filesBig addObject:searchLastFile];
    }
    
    if ([elementName isEqualToString:@"body"]) {
        if (thing!=nil)
        {
            //thing number X parsed, added ro things
            //NSLog(@"! %@", [files objectAtIndex:0]);
            thing.files = files;
            thing.filesBig = filesBig;
            [things addObject:thing];
        }
        thing = nil;
        //NSLog(@"things = thing");
    }

    currentElementValue = nil;
}


@end
