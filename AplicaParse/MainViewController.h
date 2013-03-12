//
//  MainViewController.h
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate, UIPageViewControllerDataSource>
{
    NSMutableArray *thingsArray; //main array
    NSMutableArray *filteredStrings; //filtred array
    UITableView *mainTable; //main table
    int cellHeight; //height of cell
    NSOperationQueue *myQueue; //main que
    int numrows; //numrows visible at the first moment' (while we dont scrolling bottom)
    int numRowsLoadToBottom; //numrows that we UPload when we are in the bottom
    
    //for wait while data is loading
    UIActivityIndicatorView *indicator;
    UILabel *hideLabel;
    
    //for search
    UISearchBar *searchBar;
    BOOL isFiltered;
    
    //Photo Pagination
    NSMutableArray *photos;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSArray *photos;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(void) createTable;
-(void)getDataFromCoreData;
-(void)dataLoading;
-(void)parseXml;
-(void)loadImages;

@end
