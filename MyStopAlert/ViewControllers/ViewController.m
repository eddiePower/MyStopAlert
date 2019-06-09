//
//  ViewController.m
//  MyStopAlert
//
//  Created by Eddie Power on 2/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//  Example Stop JSON Object.
//  "disruption_ids": [],  <-- not using atm
//  "stop_suburb": "Armadale",
//  "stop_name": "Armadale Station",
//  "stop_id": 1008,
//  "route_type": 0,
//  "stop_latitude": -37.8564529,
//  "stop_longitude": 145.019333,
//  "stop_sequence": 23
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *url;
    GenerateSigniture *getSigniture = [[GenerateSigniture alloc] init];
    NSString *lineNumber = @"6"; //hardcoded to frankston line for now.
    const NSString *baseUrl = @"http://timetableapi.ptv.vic.gov.au/v3/";
    //stops/route/6/route_type/0?direction_id=1&stop_disruptions=true&devid=3000745&signature=10A52B8D2DC7026545673C2986EE12B40D2A6AD4
    
    url = [getSigniture generateURLWithDevIDAndKey: [NSString stringWithFormat:@"%@stops/route/%@/route_type/0", baseUrl, lineNumber]];
    
   // NSLog(@"URL in add stop controller is: %@", url);
    
    myTable.dataSource = self;
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: url]];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    // allocate the memory of your array
    myMutableArray = [NSMutableArray array];
    
    // check your dictionary contains values or not
    if (json)
    {
        // add the data to your array
        [myMutableArray addObject:json];
        
        //sort the data by stop sequence - Frankston Line only in demo.
        sortedArray = [self sortStopsDictionary: myMutableArray];
        
        //rebuild our table data calling the cellForRowIndex method.
        [myTable reloadData];
    }
    
}

-(NSArray *) sortStopsDictionary:(NSMutableArray *) myMutableArray
{
    //sort array on the stop sequence key which we get when requesting all stops on a specific route.
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"stop_sequence" ascending:YES];
    NSArray *tmpSortedArray = [[NSArray arrayWithArray: [[[myMutableArray objectAtIndex: 0] allValues] objectAtIndex: 0]] sortedArrayUsingDescriptors:@[sd]];
    
    return tmpSortedArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
   return @"Frankston Stops - Frankston to City.";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"StopCellView";
    StationTableViewCell *cell = [myTable dequeueReusableCellWithIdentifier: cellId];

    NSMutableDictionary *stopForRowIndex = [sortedArray objectAtIndex: indexPath.row];
  
    cell.txtStopName.text = [stopForRowIndex valueForKey:@"stop_name"];
    cell.txtStopSuburb.text = [stopForRowIndex valueForKey:@"stop_suburb"];
    cell.txtStopLatitude.text = [NSString stringWithFormat:@"%@", [stopForRowIndex valueForKey:@"stop_latitude"]];
    cell.txtstopLongitude.text = [NSString stringWithFormat:@"%@", [stopForRowIndex valueForKey:@"stop_longitude"]];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection: (NSInteger)section
//{
//    NSString *footerTitle = @"";
//
//
//    return footerTitle;
//}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [myTable deselectRowAtIndexPath:indexPath animated:YES];
    StationTableViewCell *cell = [myTable cellForRowAtIndexPath:indexPath];
//    NSLog(@"Section:%ld Row:%ld selected and its data is\nStop Name: %@\nStop Suburb: %@\nStop Latitude: %@\nStop Longitude: %@",  (long)indexPath.section,(long)indexPath.row,cell.txtStopName.text, cell.txtStopSuburb.text, cell.txtStopLatitude.text, cell.txtstopLongitude.text);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%lu", (unsigned long)((NSDictionary *)[myMutableArray objectAtIndex: 0][@"stops"]).count);
    return ((NSDictionary *)[myMutableArray objectAtIndex: 0][@"stops"]).count;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    return CGSizeMake(100, 100);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"stopInfoSegue"])
    {
        NSIndexPath *indexPath = [myTable indexPathForCell: (StationTableViewCell *)sender];//[myTable indexPathForSelectedRow];
        StopDetailViewController *stopDetailViewController = [segue destinationViewController];
        stopDetailViewController.stopSuburb = [sortedArray objectAtIndex: indexPath.row][@"stop_suburb"];
        stopDetailViewController.stopName = [sortedArray objectAtIndex: indexPath.row][@"stop_name"];
        stopDetailViewController.stopLong = [sortedArray objectAtIndex: indexPath.row][@"stop_longitude"];
        stopDetailViewController.stopLatt = [sortedArray objectAtIndex: indexPath.row][@"stop_latitude"];
        
    }
    else if([segue.identifier isEqualToString:@""])
    {
        
    }
    
 }


@end
