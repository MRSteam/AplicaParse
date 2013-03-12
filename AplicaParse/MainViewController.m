//
//  MainViewController.m
//  AplicaParse
//
//  Created by Stas-PC on 06.03.13.
//  Copyright (c) 2013 Stas-PC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "mainCell.h"
#import "Data.h"
#import "XMLParser.h"
#import "MWPhotoBrowser.h"

#import "Things.h"
#import "PhotoViewController.h"


@implementation MainViewController
@synthesize photos = _photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Животные";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //clear CoreData
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate clearContext:@"Data"];
    
    cellHeight = 110;
    numrows = 10;
    numRowsLoadToBottom = 5;
    
    indicator = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(160, 195);
    
    hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    hideLabel.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.7f];
    hideLabel.textColor = [UIColor whiteColor];
    hideLabel.font = [UIFont fontWithName:@"Areal-Bold" size:18];
    hideLabel.textAlignment = UITextAlignmentCenter;
    hideLabel.text = @"\nLoading data...";
    [self.view addSubview:hideLabel];
    
    [self.view addSubview:indicator];
    [indicator startAnimating];
    [self performSelector:@selector(dataLoading) withObject:self afterDelay:0];
}

-(void) createTable
{
    //create table and searhbar
    UIColor *bgColor = [UIColor colorWithRed:0.9686 green:0.9686 blue:0.9686 alpha:1];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 415-44)];
    mainTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = bgColor;
    
    [self.view addSubview:mainTable];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    
}

-(void)getDataFromCoreData
{
    NSError *error;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    thingsArray = [[[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    
    if ([thingsArray count] < 10) numrows = [thingsArray count];
    else numrows = 10;
}

-(void)dataLoading
{
    //test on Data
    [self getDataFromCoreData];
    
    if ([thingsArray count]==0)
    {

        [self parseXml]; //load and parse data
        [self loadImages]; //load images
        
    }
    [self createTable]; //init table
    hideLabel.hidden=YES;
    [indicator stopAnimating];
}

-(void)parseXml
{
    // Download and parse
    NSString *url_str = @"http://commonservice.dmir.ru/webservices/Announcements.asmx/SearchAnnouncementsByDaysAgo?rubricId=dmir_737&locationId=1&DaysAgo=&pageNum=0&pageSize=25";
    
    NSURL *url = [NSURL URLWithString:url_str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    NSString *webStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    webStr = [webStr stringByReplacingOccurrencesOfString:@"&lt;br /&gt;"
                                               withString:@" "];
    
    NSData *webData = [webStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:webData];
    
    // create and init our delegate
    XMLParser *parser = [[XMLParser alloc] initXMLParser];
    
    // set delegate
    [nsXmlParser setDelegate:parser];
    
    // parsing...
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        NSLog(@"No errors - things count : %i", [[parser things] count]);
        
        //save data to coredata
        for (int i=0; i < [[parser things] count]; i++) {
            Things *thing = [[parser things] objectAtIndex:i];
            
            Data *data = [NSEntityDescription insertNewObjectForEntityForName:@"Data" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
            
            data.name = thing.name;
            data.price = thing.price;
            data.text = thing.text;
            data.files = [NSKeyedArchiver archivedDataWithRootObject:thing.files];
            data.filesBig = [NSKeyedArchiver archivedDataWithRootObject:thing.filesBig];
            [appDelegate saveContext];
            
            thing = nil;
        }
    } else {
        NSLog(@"Error parsing document!");
    }

}

-(void)loadImages
{
    [self getDataFromCoreData];
    
    // Load images
    myQueue = [[NSOperationQueue alloc] init];
    myQueue.maxConcurrentOperationCount = 10;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    for (int i=0; i < [thingsArray count]; i++) {
        //smallsize
        NSLog(@"Small and Big images № %d to %d",i,[thingsArray count]-1);
        Data *data = [thingsArray objectAtIndex:i];
        NSMutableArray *newFiles = [[NSMutableArray alloc] init];
        NSMutableArray *urlString = [NSKeyedUnarchiver unarchiveObjectWithData:data.files];
        
        for (int k=0; k < [urlString count]; k++) {
            [myQueue addOperationWithBlock:^{
                NSURL *url = [NSURL URLWithString:[urlString objectAtIndex:k]];
                NSData *newData = [NSData dataWithContentsOfURL:url];
                [newFiles addObject:newData];
            }];
        }
        [myQueue waitUntilAllOperationsAreFinished];
        data.files = [NSKeyedArchiver archivedDataWithRootObject:newFiles];
        
        //bigsize
        newFiles = [[NSMutableArray alloc] init];
        urlString = [NSKeyedUnarchiver unarchiveObjectWithData:data.filesBig];
        
        for (int k=0; k < [urlString count] ; k++) {
            [myQueue addOperationWithBlock:^{
                NSURL *url = [NSURL URLWithString:[urlString objectAtIndex:k]];
                NSData *newData = [NSData dataWithContentsOfURL:url];
                [newFiles addObject:newData];
            }];
        }
        [myQueue waitUntilAllOperationsAreFinished];
        data.filesBig = [NSKeyedArchiver archivedDataWithRootObject:newFiles];
        [appDelegate saveContext];
    }
}



#pragma mark UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numrows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    mainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[mainCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    Data *data;
    if (!isFiltered)
    {
        data = [thingsArray objectAtIndex:indexPath.row];
    }
    else
    {
        data = [filteredStrings objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = data.name;
    cell.priceLabel.text = [data.price stringByAppendingString: @" руб."];
    cell.photoImageView.image = [UIImage imageNamed:@"Default.png"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data.files];
    cell.photoImageView.image = [UIImage imageWithData:[array objectAtIndex:arc4random() % ([array count])]];
    cell.numPhotoLabel.text = [NSString stringWithFormat:@"%d фото",[[NSKeyedUnarchiver unarchiveObjectWithData:data.filesBig] count]];
    cell.textLabel.text = data.text;

    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (mainTable.contentOffset.y>=cellHeight*(numrows-4)) {
    //NSLog(@"Did Scroll %f", mainTable.contentOffset.y);
        
    [mainTable beginUpdates];
    
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    int count;
        
    if (isFiltered) count = [filteredStrings count];
    else count = [thingsArray count];
            
    int i=-1;
        
    
    while (i < numRowsLoadToBottom) {
        i++;
        if (numrows+i != count)
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:numrows+i inSection:0];
            [indexArray insertObject:path atIndex:i];
        }
        else
        {
            i--;
            break;
        }
    }
        
    numrows=numrows+(i+1);
    [mainTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationRight];
    // make sure the dataSource will return new rows before calling endUpdates
    [mainTable endUpdates];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    mainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[mainCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PhotoViewController *PVC = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    
    Data *data;
    if (!isFiltered)
    {
        data = [thingsArray objectAtIndex:indexPath.row];
    }
    else
    {
        data = [filteredStrings objectAtIndex:indexPath.row];
    }
    
    //MWPhotoBrowser - Photo Pagination
    NSMutableArray *images = [NSKeyedUnarchiver unarchiveObjectWithData:data.filesBig];
    NSMutableArray *phot = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    for (int i=0; i < [images count]; i++) {
        photo = [MWPhoto photoWithImage:[UIImage imageWithData:[images objectAtIndex:i]]];
        [phot addObject:photo];
    }
    
    self.photos = phot;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    
    [self.navigationController pushViewController:browser animated:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    NSIndexPath *selectedIndexPath = [mainTable indexPathForSelectedRow];
    [mainTable deselectRowAtIndexPath:selectedIndexPath animated:NO];
}


#pragma mark UISearchBarDelegate 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text=@"";
    isFiltered = NO;
    [mainTable reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = NO;
        if ([thingsArray count] < 10) numrows = [thingsArray count];
        else numrows = 10;
    }
    else {
        isFiltered = YES;
        filteredStrings = [[NSMutableArray alloc]init];
        
        NSString *str1;
        NSMutableArray *filteredStringsInArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[thingsArray count]; i++) {
            Data *data = [thingsArray objectAtIndex:i];
            str1 = data.name;
            
            NSRange stringRange1 = [str1 rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange1.location != NSNotFound) {
                [filteredStrings addObject:data];
            }
        }
        if ([filteredStrings count] < 10) numrows = [filteredStrings count];
        else numrows = 10;
       
    }
    NSLog(@"NumRows: %d",numrows);
    [mainTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

@end
