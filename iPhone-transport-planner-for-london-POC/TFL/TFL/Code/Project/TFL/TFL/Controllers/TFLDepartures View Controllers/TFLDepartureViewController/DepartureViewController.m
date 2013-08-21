//
//  DepartureViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DepartureViewController.h"
#import "DepartureDetailViewController.h"

@implementation DepartureViewController
{ 
    NSMutableArray *optionsArray;
    NSString *stationName;
    NSString *lineName;
    NSMutableArray *lines;
    NSMutableArray *StationNames;
    NSMutableArray *stationCodes;
    NSInteger stationIndex;
    NSMutableArray *lineCodes;
    NSMutableArray *stations;
}
@synthesize tubeButton;
@synthesize DLRButton;

@synthesize departureTableView;
@synthesize departureImageView;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize findButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        }
    return self;
}

- (void)didReceiveMemoryWarning
{
  
    [super didReceiveMemoryWarning];
    
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.departureImageView.image = [UIImage imageNamed:@"Underground.png"]; 
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"top_bg.png"]]]; 
   [self.departureTableView setBackgroundColor:[UIColor whiteColor]];
    self.title = NSLocalizedStringFromTable(@"Departures", @"Localization", @"");
    self.departureTableView.dataSource = self;
    self.departureTableView.delegate = self;
    stationCodes =[[NSMutableArray alloc]init];
    lines = [[NSMutableArray alloc]init];
    StationNames = [[NSMutableArray alloc]init];
    lineCodes = [[NSMutableArray alloc]init];
        
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
   
    [self.tubeButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
    self.DLRButton.titleLabel.textColor = [UIColor whiteColor];
    self.tubeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    self.DLRButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];

    if(![standardUserDefaults objectForKey:@"Stations_Added"])
    {
        [standardUserDefaults setBool:YES forKey:@"Stations_Added"];
         stationCodesFetcher *station = [[stationCodesFetcher alloc]init];
        [station Parser];
    }    
    
    [self.findButton setTitle:NSLocalizedStringFromTable(@"Find All Departures", @"Localization", @"") forState:UIControlStateNormal];
    [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_red.png"] forState:UIControlStateNormal];
}
- (void)viewDidUnload
{
    [self setDepartureTableView:nil];
    [self setDepartureTableView:nil];
    [self setDepartureImageView:nil];
    [self setTubeButton:nil];
    [self setDLRButton:nil];
    [self setFindButton:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    if([lineName isEqualToString:@"DLR"]&& section==0)
        return @"";
    else if(section ==0)
        return NSLocalizedStringFromTable(@"Pick a Line", @"Localization", @"");
    else
        return NSLocalizedStringFromTable(@"Pick a Station", @"Localization", @"");
        
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundColor = [UIColor clearColor];
    
    imageView.image = [UIImage imageNamed:@"cell_single_normal.png"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView = imageView; 
    
    switch ([indexPath section]) {
        case 0:
            
            if([lineName isEqualToString:@"DLR"])
                [cell setHidden:YES];
                cell.textLabel.text = lineName;
            
            break;
      
        case 1:
            
            cell.textLabel.text = stationName;
            
            break;
            
        default:
            break;
    }
    
    return cell;
    
}
- (IBAction)findButtonPressed:(id)sender {
    
    if( [CheckNetwork isConnectedToNetwork]){
    
    if(lineName&&stationName){
      [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_green_pressed.png"] forState:UIControlStateSelected];
    if([lineName isEqualToString:@"DLR"])
        [self performSegueWithIdentifier:@"DLR" sender:self];
    else
    [self performSegueWithIdentifier:@"FindDepartures" sender:self];
    }
    else if(lineName&&!stationName){
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Missing" message:@"Pls Select a Station" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
       
    }
    else {
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Missing" message:@"Pls Select a Tube and Station" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
        
    }
}
    else{
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not Connected to Internet" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
        return;
    }
 
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"options"])
    {
        
        pickAnOptionViewController *pickoption = [segue destinationViewController];
        pickoption.options = StationNames;
        pickoption.tag = [NSString stringWithFormat:@"0"];
        pickoption.delegate =self;
        
    }
   else if([segue.identifier isEqualToString:@"lineCodes"])
    {
       
        pickAnOptionViewController *pickoption = [segue destinationViewController];
        pickoption.options =lines;
        pickoption.tag = [NSString stringWithFormat:@"1"];
        pickoption.delegate = self;
    }
    
   else if([segue.identifier isEqualToString:@"DLR"]){
        
        DLRDetailViewController *detail = [segue destinationViewController]; 
        detail.stationName = [stationCodes objectAtIndex:stationIndex];
        detail.station = stationName;
        
    }
    
   else if([segue.identifier isEqualToString:@"FindDepartures"]){
        
         
        DepartureDetailViewController *detailView = [segue destinationViewController];
        detailView.searchDepartures = [NSString stringWithFormat:@"%@/%@",[lineName substringToIndex:1],[stationCodes objectAtIndex:stationIndex]];
        detailView.statioName = stationName;
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.departureTableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"cell_single_pressed.png"];
    
    switch ([indexPath section]) {
        case 0:
            
            if(stationName) stationName = nil;
            [self fetchUniqueRecords];
            if(![lineName isEqualToString:@"DLR"])
                [self performSegueWithIdentifier:@"lineCodes" sender:self];
            
           
            
            break;
         
        case 1:
            if(lineName){
                [self fetchRecords];
                [self fetchStationsForTubeLine];
                [self performSegueWithIdentifier:@"options" sender:self];
            }
            else{
                
                UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Missing" message:@"Pls Select a Tube" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                [noInternetConnectionAlert show];
            }
                    
            break;
        
        default:
            break;
            
    }
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView = imageView; 
}

- (void)fetchRecords {
	
	stations = [[NSMutableArray alloc]init ];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];

    
	NSError *error;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
        
		NSLog(@"Sorry No Data");
	}
    
    NSInteger i;
    
    optionsArray = [[NSMutableArray alloc]init];
    
    NSLog(@"%d",[mutableFetchResults count]);
    
    for(i=0;i<[mutableFetchResults count];i++){
        
        NSMutableDictionary *stationsDict = [[NSMutableDictionary alloc]init];
        
        Stations *stationsEntity = [mutableFetchResults objectAtIndex:i];
       
        [stationsDict setObject:[stationsEntity stationName] forKey:@"stationName"];
        [stationsDict setObject:[stationsEntity stationCode] forKey:@"stationCode"];
        [stationsDict setObject:[stationsEntity lineCode] forKey:@"lineCode"];
        [stationsDict setObject:[stationsEntity lineName] forKey:@"lineName"];
        [StationNames addObject:[stationsEntity stationName]];
        [optionsArray addObject:stationsDict];
    }  
}

-(void) fetchUniqueRecords{
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lineName!=%@",@"DLR"];
    [request setPredicate:predicate];
    
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"lineName"]];
    request.returnsDistinctResults = YES;
    request.resultType = NSDictionaryResultType;
    
	NSError *error;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
        
		NSLog(@"Sorry No Data");
	}
    NSInteger i;
   for(i=0;i<[mutableFetchResults count];i++){

       [lines addObject:[[mutableFetchResults objectAtIndex:i]objectForKey:@"lineName"]];
   }
    
}

-(void) fetchStationsForTubeLine{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stations" inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lineName==%@",lineName];
    [request setPredicate:predicate];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
        
		NSLog(@"Sorry No Data");
	}
    NSInteger i;
    [StationNames removeAllObjects];
    [stationCodes removeAllObjects];
    [lineCodes removeAllObjects];
    
    for(i=0;i<[mutableFetchResults count];i++){
        
        Stations *stationInfo = [mutableFetchResults objectAtIndex:i];
        [StationNames addObject:[stationInfo stationName]];
        [stationCodes addObject:[stationInfo stationCode]];
        [lineCodes addObject:[stationInfo lineCode]];
    }
}

- (IBAction)tubeButtonPressed:(id)sender {
    
     [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_red.png"] forState:UIControlStateNormal];
   
    [self.tubeButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
  
    self.DLRButton.titleLabel.textColor = [UIColor whiteColor];
    self.tubeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    self.DLRButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
    
    self.departureImageView.image = [UIImage imageNamed:@"Underground.png"]; 
    lineName = nil;
    stationName =nil;
    [self.departureTableView reloadData];
    
}

- (IBAction)DLRButtonPressed:(id)sender {

    [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_red.png"] forState:UIControlStateNormal];
    
    [self.DLRButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
    
    self.tubeButton.titleLabel.textColor = [UIColor whiteColor];
    self.DLRButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    self.tubeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
   
    
    self.departureImageView.image = [UIImage imageNamed:@"DLR.png"]; 
    lineName = @"DLR";
    stationName = nil;
    [self fetchStationsForTubeLine];
    [self.departureTableView reloadData];

}
-(void) sendSelectedStation:(NSInteger)index withTag:(NSString *)tag{
  
    if([tag isEqualToString:@"0"]){
        stationName = [StationNames objectAtIndex:index];
        stationIndex = index;
    }
    if([tag isEqualToString:@"1"]){
    lineName =[lines objectAtIndex:index]; 

    }
    if(stationName&&lineName){
        
        [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_green_normal.png"] forState:UIControlStateNormal];
    }
    else{
         [self.findButton setBackgroundImage:[UIImage imageNamed:@"btn_find_red.png"] forState:UIControlStateNormal];
    }
    [self.departureTableView reloadData];
}

@end
