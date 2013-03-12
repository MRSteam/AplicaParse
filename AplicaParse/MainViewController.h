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

@property (strong, nonatomic) UIWindow *window;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(void) createTable;
-(void)getDataFromCoreData;
-(void)dataLoading;
-(void)parseXml;
-(void)loadImages;

@end
