    //
//  TFLFirstViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLPlannerViewController.h"
#import "PlacesFetcher.h"

@interface TFLPlannerViewController()

@property (readonly) CLLocationCoordinate2D currentUserCoordinate;
@property (strong , nonatomic) CLPlacemark *placemark;
@end

@implementation TFLPlannerViewController
{
    
   NSMutableArray *placesArray;
   NSArray *locationTypeData;
   NSString *selectedOriginLocationType;
   NSString *selectedDestinationLocationType;
   BOOL changeView;
   BOOL hidePicker1;
   BOOL hidePicker2;
    BOOL hideDatePicker;
   BOOL isLongPressGestureDone;
    BOOL isFromButtonPressed;
    BOOL isToButtonPressed;
    BOOL hideTypeArrDepPicker;
    BOOL checkChangeViewButton;
    BOOL checkExceptionForSelection;
    BOOL checkCreatedAnnotations;
   NSString *origin;
   NSString *destination;
   NSDate *selectedDate;
   NSMutableArray *placeArray;
   NSInteger datePickCount;
   NSString *selectedLat;
   NSString *selectedLon;
   NSArray *searchQueryResults;
    NSMutableArray *annotationArray;
    NSString *selectedPlaceName;
    NSString *selectedPlaceAddress;
    NSArray *typeArrDep;
    NSString *selectedArrDepType;
    NSString *selectedFrom;
    NSString *selectedTo;
    NSUInteger indexForNavigation;
    NSMutableDictionary *mapCoordinate;
    NSArray *navigationMessage;
    BOOL fromSelected;
    BOOL toSelected;
    BOOL listView;
    BOOL mapView;
    MKPolyline *polyLine ;
    NSInteger selectedPicker;
    UITapGestureRecognizer *tapGestureRecognizerFrom;
    UITapGestureRecognizer *tapGestureRecognizerTo;
    
    NSString *travelPreferences;
  
}
@synthesize placemark = _placemark;
@synthesize currentUserCoordinate = _currentUserCoordinate;
@synthesize placesTableView = _placesTableView;
@synthesize searchResultsTableView = _searchResultsTableView;
@synthesize mapView = _mapView ;
@synthesize searchButton = _searchButton;
@synthesize annotations = _annotations;
@synthesize searchBar = _searchBar;
@synthesize listView = _listView;
@synthesize mapsView = _mapsView;
@synthesize searchView = _searchView;
@synthesize selectedAnnotation = _selectedAnnotation;
@synthesize bottom_lineImageView = _bottom_lineImageView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize changeViewButton;
@synthesize annotation = _annotation;
@synthesize picker = _picker;
@synthesize datePicker = _datePicker;
@synthesize depArrPickerView = _depArrPickerView;
@synthesize placesAnnotation = _placesAnnotation;
@synthesize routeAnnotations = _routeAnnotations;
@synthesize doneView;
@synthesize doneButton;
@synthesize cancelButton;


@synthesize longPressCalloutAnnotation = _longPressCalloutAnnotation;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    self.doneView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
    indexForNavigation = 0;
   
    datePickCount = 2;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.picker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.listView setHidden:YES];
   
    [self.placesTableView setBackgroundColor:[UIColor clearColor]];
   
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.searchBar.delegate = (id)self;
	self.searchBar.hidden = YES;
    
    UIImageView* iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_box_with_icon.png"]];
    iview.frame = CGRectMake(0, 0, 320, 44);
    [self.searchBar insertSubview:iview atIndex:1];

    checkChangeViewButton = YES;
    
    placesArray = [[NSMutableArray alloc]init];
    _annotation = [[NSMutableArray alloc]init];
  
    
    locationTypeData = [[NSArray alloc]initWithObjects:@"Stop",@"Address",@"PostCode",@"Place Of Interest",@"Coordinate", nil];
    typeArrDep = [[NSArray alloc]initWithObjects:@"Arrival",@"Departure", nil];
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![standardUserDefaults objectForKey:@"Map_Loc_Added"])
    {
    [standardUserDefaults setBool:YES forKey:@"Map_Loc_Added"];
     PlacesFetcher *placesFetcher = [[PlacesFetcher alloc]init];
     [placesFetcher Parser];
    }    

    [self fetchRecords];
    self.placesTableView.delegate = self;
    self.placesTableView.dataSource = self;
    
    selectedDate = [NSDate date];
    selectedArrDepType = @"Arrival";
    selectedOriginLocationType = @"Coordinate";
    origin = @"Current Location";
    annotationArray = [[NSMutableArray alloc]init];

}


- (void)viewDidUnload
{
   
    [self setMapView:nil];
    [self setSearchBar:nil];
    [self setSearchButton:nil];
    [self setListView:nil];
    [self setMapsView:nil];
    [self setPlacesTableView:nil];
    [self setBottom_lineImageView:nil];
    [self setSearchView:nil];
    [self setSearchResultsTableView:nil];
    [self setDoneView:nil];
    [self setDoneButton:nil];
    [self setCancelButton:nil];
    [self setChangeViewButton:nil];
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
  
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Fetching From Core data

- (void)fetchRecords {
    
    
    NSMutableArray *annotations= [[NSMutableArray alloc]init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"POI" inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
        
		NSLog(@"Sorry No Data");
	}
    
    NSInteger i;
    placeArray = [[NSMutableArray alloc]initWithCapacity:[mutableFetchResults count]];
    
    for(i=0;i<[mutableFetchResults count];i++){
        
        NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
        
        POI *poi = [mutableFetchResults objectAtIndex:i];
        
        [places setObject:poi.title forKey:@"name"];
        [places setObject:poi.latitude forKey:@"lat"];
        [places setObject:poi.longitude forKey:@"lng"];
        [places setObject:poi.address forKey:@"address"];
        [places setObject:poi.postalCode forKey:@"postalCode"];
        [places setObject:poi.type forKey:@"type"];
        
        [placeArray insertObject:places atIndex:i];
        
    }
    
    for (i=0;i<[placeArray count];i++) {
        
        NSDictionary *place = [placeArray objectAtIndex:i];
        self.placesAnnotation = [placesAnnotations annotationForPlace:place];
        [annotations addObject:self.placesAnnotation];
    }
    self.annotation = annotations; 
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
   [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    if (self.calloutAnnotation) {
        isLongPressGestureDone = NO;
        [self.mapView removeAnnotation:self.calloutAnnotation];
         self.selectedAnnotationView =  nil;
    }
    if(isLongPressGestureDone){
    checkExceptionForSelection = YES;
    }
    self.calloutAnnotation = [[CalloutMapAnnotation alloc]initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
    
    [self.mapView addAnnotation:self.calloutAnnotation];
    self.selectedAnnotationView = view; 
    NSInteger i;
    for (i=0; i<[annotationArray count]; i++) {
        if([annotationArray objectAtIndex:i] == view.annotation){
            
            NSLog(@"%f %f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
            
            selectedLat = [NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude];
            selectedLon = [NSString stringWithFormat:@"%f", view.annotation.coordinate.longitude];
          
            checkCreatedAnnotations = YES;
        }
    }

}

    

//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//   
//    MKAnnotationView *aV;
//       for (aV in views) {
//        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
//            MKAnnotationView* annotationView = aV;
//            annotationView.canShowCallout = NO;
//            
//        }
//    }    
//
//}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    if (self.calloutAnnotation) {
        [self.mapView removeAnnotation:self.calloutAnnotation];
        self.selectedAnnotationView =  nil;
    }
}

#pragma mark User Location Update
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{		
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    
    _currentUserCoordinate = [newLocation coordinate];
}


-(void)fromButtonTapped:(UITapGestureRecognizer *)tgr{
    
    [self directionFromButtonPressed:self.mapView];
    
}

-(void)toButtonTapped:(UITapGestureRecognizer *)tgr{
    
    [self directionToButtonPressed];
}
#pragma mark MapView and Annotations

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.calloutAnnotation) {
		
         
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		
        calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
                                                                        reuseIdentifier:@"CalloutAnnotation"];
        calloutMapAnnotationView.contentHeight = 130.0f;
        
        UIImage *asynchronyLogo = [UIImage imageNamed:@"tool_tip_icon_home.png"];
        UIImageView *asynchronyLogoView = [[UIImageView alloc] initWithImage:asynchronyLogo];
        asynchronyLogoView.frame = CGRectMake(5, 2, 35,35);
        [calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
        
        UILabel *title = [[UILabel alloc]init];
        if(isLongPressGestureDone&&!checkExceptionForSelection){
            title.text = selectedPlaceName;
        
        }
        else {
            title.text =  [[self.mapView.selectedAnnotations objectAtIndex:0] title];
            
        }
        title.frame = CGRectMake(40.0, -10.0, 120.0, 50.0);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        
        UILabel *subtitle =[[UILabel alloc]init];
        subtitle.frame = CGRectMake(40.0, 10.0, 120.0, 50.0);
        subtitle.lineBreakMode = UILineBreakModeWordWrap;
        subtitle.numberOfLines = 2;
        if(isLongPressGestureDone&&!checkExceptionForSelection){
            subtitle.text = selectedPlaceAddress;
            checkExceptionForSelection = NO;
            
        }
        else{
            subtitle.text = [[self.mapView.selectedAnnotations objectAtIndex:0] subtitle];
        }
        
        subtitle.font = [UIFont systemFontOfSize:9];
        subtitle.textColor = [UIColor whiteColor];
        subtitle.backgroundColor = [UIColor clearColor];
        
        if(origin&&destination){
            isFromButtonPressed = NO;
            isToButtonPressed = NO;
        }
        
        UIButton *directionsFromHere = [[UIButton alloc]init];
        [directionsFromHere setTitle:@"Directions From Here" forState:UIControlStateNormal];
        directionsFromHere.frame = CGRectMake(10.0,50.0,150.0,25.0);
        [directionsFromHere setBackgroundImage:[UIImage imageNamed:@"tool_tip_btn_pressed.png"] forState:UIControlStateSelected];
        [directionsFromHere setBackgroundImage:[UIImage imageNamed:@"tool_tip_btn_normal.png"] forState:UIControlStateNormal];
        
        directionsFromHere.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        [directionsFromHere addTarget:self 
                               action:@selector(directionFromButtonPressed:) 
                     forControlEvents:UIControlEventTouchUpInside];
        
        self.selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
        
        UIButton *directionsToHere = [[UIButton alloc]init];
        [directionsToHere setTitle:@"Directions To Here" forState:UIControlStateNormal];
        directionsToHere.frame = CGRectMake(10.0, 80.0,150.0,25.0);
        [directionsToHere setBackgroundImage:[UIImage imageNamed:@"tool_tip_btn_pressed.png"] forState:UIControlStateSelected];
        [directionsToHere setBackgroundImage:[UIImage imageNamed:@"tool_tip_btn_normal.png"] forState:UIControlStateNormal];
        directionsToHere.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        [directionsToHere addTarget:self action:@selector(directionToButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        [calloutMapAnnotationView.contentView addSubview:title];
        [calloutMapAnnotationView.contentView addSubview:subtitle];
        
        
        if(!isFromButtonPressed){
            [calloutMapAnnotationView.contentView addSubview:directionsFromHere];
        }
        if(!isToButtonPressed){
            [calloutMapAnnotationView.contentView addSubview:directionsToHere];
        }
        
        
        
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
      
        tapGestureRecognizerFrom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromButtonTapped:)];
        [directionsFromHere addGestureRecognizer:tapGestureRecognizerFrom];
        
        tapGestureRecognizerTo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toButtonTapped:)];
        [directionsToHere addGestureRecognizer:tapGestureRecognizerTo];
    
        
       
        
        
		return calloutMapAnnotationView;
	}
        
            
    else{
        
        static NSString *identifier = @"Places Annotations";
        MKAnnotationView *aView = (id)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
            aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
          
            aView.canShowCallout = NO;
            UIImage *pinImage = [self makeThumbnailOfSize:CGSizeMake(25.0,25.0) withImage:[UIImage imageNamed:@"pin_without_shadow.png"]];
        
        if ([annotation isKindOfClass:[MKUserLocation class]]){
            pinImage =  [self makeThumbnailOfSize:CGSizeMake(25.0,25.0) withImage:[UIImage imageNamed:@"location_pin.png"]];

        }
        
        
        [aView setImage:pinImage];
        aView.canShowCallout = NO;
        aView.annotation = annotation;
        aView.enabled = YES;
        
    
                
        return aView;
    }
    
    return nil;
}


-(void) directionFromButtonPressed:(MKMapView *)mapView{
   
    if(checkCreatedAnnotations|| selectedFrom == [self.selectedAnnotation title]){
        
        selectedFrom = [self.selectedAnnotation title];
        selectedOriginLocationType = @"Coordinate";
        origin = [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",[selectedLon doubleValue],[selectedLat doubleValue]];
        checkCreatedAnnotations = NO;
        
    }
    else if(isLongPressGestureDone){
        
        selectedFrom = selectedPlaceName;
        origin =    [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",[selectedLon doubleValue],[selectedLat doubleValue]];
        selectedOriginLocationType = @"Coordinate";
        isLongPressGestureDone = NO;
    }
    else if([[self.selectedAnnotation title] isEqualToString:@"Current Location"]){
        
        origin = [self.selectedAnnotation title];
        selectedOriginLocationType = @"Coordinate";
        
    }
    else{
        
        origin = [self.selectedAnnotation title];
        selectedOriginLocationType = @"Place Of Interest";
        selectedFrom = nil;
    }
    isFromButtonPressed = YES;
    [self.placesTableView reloadData];
    
    [self.mapsView setHidden:[self.listView isHidden]];
    [self.listView setHidden:![self.mapsView isHidden]];
    
}
-(void) directionToButtonPressed{
    
    
    
    if(checkCreatedAnnotations||selectedTo == [self.selectedAnnotation title]){
        
        selectedTo= [self.selectedAnnotation title];
        selectedDestinationLocationType = @"Coordinate";
        destination = [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",[selectedLon doubleValue],[selectedLat doubleValue]];
        checkCreatedAnnotations = NO;
        
    }
    else if(isLongPressGestureDone){
        selectedTo = selectedPlaceName;
        destination = selectedPlaceName;
        destination =    [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",[selectedLon doubleValue] ,[selectedLat doubleValue]];
        selectedDestinationLocationType = @"Coordinate";
        isLongPressGestureDone = NO;
    }
    else if([[self.selectedAnnotation title] isEqualToString:@"Current Location"]){
        
        destination = [self.selectedAnnotation title];
        selectedDestinationLocationType = @"Coordinate";
        
    }
    else{
        
         selectedTo = nil;
        destination = [self.selectedAnnotation title];
        selectedDestinationLocationType = @"Place Of Interest";
    }
    
    isToButtonPressed = YES;
    [self.placesTableView reloadData];
    
    [self.mapsView setHidden:[self.listView isHidden]];
    [self.listView setHidden:![self.mapsView isHidden]];
        
    

}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{ 
    self.selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
    
    if([control tag]==1){
        
        destination = [self.selectedAnnotation title];
    }
    else if([control tag]==2){
        
        origin = [self.selectedAnnotation title];
        
    }
    
    [self.placesTableView reloadData];
   
    [self.mapsView setHidden:[self.listView isHidden]];
    [self.listView setHidden:![self.mapsView isHidden]];
    
}

- (void) updateMapView
{
    [self.mapView addAnnotations:_annotation];
}

-(void) setMapView:(MKMapView *)mapView{
    
    _mapView = mapView;
   [self performSelectorOnMainThread:@selector(updateMapView) withObject:nil waitUntilDone:YES];
}

-(void) setAnnotation:(NSMutableArray *)annotation{
    
    _annotation = annotation;
    [self performSelectorOnMainThread:@selector(updateMapView) withObject:nil waitUntilDone:YES];
}
- (void) searchBarTextDidBeginEditing:(UISearchBar *)sender
{
    if(searchQueryResults){
        searchQueryResults = nil;
        [self.searchResultsTableView reloadData];
    }
    
    
    self.searchBar.showsCancelButton=YES;
   
}

#pragma mark Search Bar Fucntions

- (IBAction)searchButtonClicked:(id)sender {
    
    self.searchBar.showsCancelButton=YES;
    self.searchBar.hidden = NO;
    self.searchButton.hidden = YES;
    self.searchResultsTableView.dataSource = self;
    self.searchResultsTableView.delegate = self;
    [self.searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)sender{

    
    [self.searchResultsTableView setHidden:NO];
    [self.searchView setHidden:NO];
    [self.view bringSubviewToFront:self.searchView];

   
    
    TFLSearchModel *search = [[TFLSearchModel alloc]init];
    search.dataDelegate = self;
    
    if([[sender text]length] >0){
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("Search Results Downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        [search searchForPlaces:[sender text]];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.searchResultsTableView reloadData];
        });
    });
    
    dispatch_release(downloadQueue);
    
    }
    else{
        UIAlertView *noSearchText = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Pls Enter Some Data to Search" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noSearchText show];
    }
    
    [self.searchBar resignFirstResponder];
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sender{

    self.searchBar.text=@"";
    [self.searchBar resignFirstResponder];
    [self.searchView setHidden:YES];
    self.searchBar.hidden = YES;
    self.searchButton.hidden = NO;
    self.searchBar.showsCancelButton=NO;
    
}
#pragma  mark Searhced Results Delegate Method

-(void) sendResponseForQuery:(NSArray *)data{
    

    searchQueryResults = data;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
}


#pragma mark tableView delegate methods

-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([tableView isEqual:self.searchResultsTableView]){

        return [searchQueryResults count];
    }
    else{
    if(section ==3|| section ==4)
        return 1;
    else 
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if([tableView isEqual:self.searchResultsTableView]){
        return 1;
    }
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if([tableView isEqual:self.searchResultsTableView]){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResulsCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchResulsCell"];
        }
        cell.textLabel.text = [[searchQueryResults objectAtIndex:indexPath.row]objectForKey:@"name"];
       return cell;
  
    }
    else
    {
        
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        }
       
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds]; 
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cell.backgroundView = imageView;
        
        switch ([indexPath section]) {
            case 0:
                
                if(indexPath.row ==0){
                    
                    cell.textLabel.text =@"From";
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if(selectedFrom){
                        cell.detailTextLabel.text = selectedFrom;
                    }
                    else{
                        cell.detailTextLabel.text = origin;
                    }
                    cell.backgroundColor = [UIColor clearColor];
                
                    imageView.image = [UIImage imageNamed:@"cell_top_normal.png"];
                   
                }
               else if(indexPath.row == 1){
                    
                    cell.textLabel.text = @"Location Type";
                    cell.detailTextLabel.text = selectedOriginLocationType;
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_normal.png"]];
                    
                    imageView.image = [UIImage imageNamed:@"cell_bottom_normal.png"];
                    
                }

                break;
   
            case 1:
                
                if(indexPath.row ==0){
                    
                    cell.textLabel.text =@"To";
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    if(selectedTo){
                        
                        cell.detailTextLabel.text = selectedTo;
                    }
                    else{
                        cell.detailTextLabel.text = destination;
                    }
                    imageView.image = [UIImage imageNamed:@"cell_top_normal.png"];
                    
                    
                }
               else if(indexPath.row == 1){
                    
                    cell.textLabel.text = @"Location Type";
                    cell.detailTextLabel.text = selectedDestinationLocationType;
                    
                    
                    imageView.image = [UIImage imageNamed:@"cell_bottom_normal.png"];
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_normal.png"]];
                }

                break;
            
                
            case 2:
                
                if(indexPath.row ==0){
                    
                    cell.textLabel.text =@"When";
                    cell.detailTextLabel.text= selectedArrDepType;
                    imageView.image = [UIImage imageNamed:@"cell_top_normal.png"];
                   cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_normal.png"]];
                    
                }
                else if(indexPath.row == 1){
                    
                    cell.textLabel.text = @"Date";
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
                    cell.detailTextLabel.text = [dateFormatter stringFromDate:selectedDate];
                    
                    imageView.image = [UIImage imageNamed:@"cell_bottom_normal.png"];
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_normal.png"]];
                    
                }

                break;
                
            case 3:
                
                if(indexPath.row ==0){
                    
                    cell.textLabel.text =@"Travel Preferences";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    imageView.image = [UIImage imageNamed:@"cell_single_normal.png"];
                    
                }
                break;
           
            case 4:
                
                if(indexPath.row ==0){
                    
                    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(90.0, 5.0, 300.0, 50.0)];
                    labelView.backgroundColor = [UIColor clearColor];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
                    label.backgroundColor = [UIColor clearColor];
                    label.text = @"Find Routes";
                    label.font = [UIFont systemFontOfSize:22];
                    label.textColor = [UIColor whiteColor];
                    [labelView addSubview:label];
                    [cell.contentView addSubview:labelView];
                    
                    if(origin&&destination&&selectedOriginLocationType&&selectedDestinationLocationType&&selectedDate){
                        imageView.image = [UIImage imageNamed:@"btn_find_green_normal.png"];
                        
                    }
                    else{
                        imageView.image = [UIImage imageNamed:@"btn_find_red.png"];
                    }
                }
                break;
                
            default:
                
                break;
        }         
        
      return cell;
    }    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 60;
    
}

#pragma mark Change View-Map/List

- (IBAction)changeViewButtonPressed:(UIButton *)sender {
    
    
    if (checkChangeViewButton == NO) {
        [self.changeViewButton setImage:[UIImage imageNamed:@"btn_list_normal.png"] forState:UIControlStateNormal];
                
        checkChangeViewButton = YES;
    }
    else
    {
        [self.changeViewButton setImage:[UIImage imageNamed:@"btn_map_normal.png"] forState:UIControlStateNormal];
            checkChangeViewButton = NO;
    }
    
     [UIView commitAnimations];
    
    [self.picker setHidden:YES];
    [self.doneView setHidden:YES];
    [self.datePicker setHidden:YES];
    [self.depArrPickerView setHidden:YES];
    [self.listView addSubview:self.bottom_lineImageView];
    [self.mapsView setHidden:[self.listView isHidden]];
    [self.listView setHidden:![self.mapsView isHidden]];
    
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.placesTableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundColor = [UIColor clearColor];
    
    if([tableView isEqual:self.searchResultsTableView]){
        
         [self.searchBar resignFirstResponder];
        
        if(fromSelected){
        origin = [[searchQueryResults objectAtIndex:indexPath.row]objectForKey:@"name"];
            fromSelected = NO;
            selectedFrom = origin;   
        }
        else if(toSelected){
        destination = [[searchQueryResults objectAtIndex:indexPath.row]objectForKey:@"name"];
            toSelected = NO;
            selectedTo = destination;
        }
            
        NSString *string = [[searchQueryResults objectAtIndex:indexPath.row]objectForKey:@"type"];
    
        if ([string rangeOfString:@"stop"].location == NSNotFound) {
        } 
        else{
            selectedDestinationLocationType = @"Stop";
        }
         if([string rangeOfString:@"places of interest"].location == NSNotFound) {
        }
         else{
             selectedDestinationLocationType = @"Place Of Interest";
         }

        [self.searchView setHidden:YES];
        [self.placesTableView reloadData];
        [self.view bringSubviewToFront:self.listView];
        [self.mapsView setHidden:[self.listView isHidden]];
        [self.listView setHidden:![self.mapsView isHidden]];
        
    }
    else{
        
    
        switch ([indexPath section]) {
            case 0:
                
                if(indexPath.row == 0){
                    [self.mapsView setHidden:[self.listView isHidden]];
                    [self.listView setHidden:![self.mapsView isHidden]];
                    fromSelected = YES;
                    
                    cell.backgroundColor = [UIColor clearColor];
                    
                    imageView.image = [UIImage imageNamed:@"cell_top_pressed.png"];
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    cell.backgroundView = imageView;
                }
                else if(indexPath.row == 1){
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_pressed.png"]]; 
                    if(!hidePicker1){
                        [self.picker setHidden:NO];
                        [self.picker setTag:1];
                        [self.view addSubview:self.picker];
                        self.doneView.hidden = NO;
                        self.doneButton.hidden = NO;
                        self.cancelButton.hidden = NO;
                        selectedPicker = 1;
                        
                        [self.placesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        hidePicker1 = YES;    
                    }
                    else{
                        [self.doneView setHidden:YES];
                        [self.picker removeFromSuperview];
                        hidePicker1 = NO;
                    }

                }
                
                break;
            case 1:
                
                if(indexPath.row == 0){
                    [self.mapsView setHidden:[self.listView isHidden]];
                    [self.listView setHidden:![self.mapsView isHidden]];
                    toSelected = YES;
                    imageView.image = [UIImage imageNamed:@"cell_top_pressed.png"];
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    cell.backgroundView = imageView; 
                    
                }
                else if(indexPath.row == 1){
                    
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_pressed.png"]]; 
                    if(!hidePicker2){
                        [self.picker setHidden:NO];
                        selectedPicker = 2;
                        [self.picker setTag:2];
                        [self.view addSubview:self.picker];
                        self.doneView.hidden = NO;
                        self.doneButton.hidden = NO;
                        self.cancelButton.hidden = NO;
                        [self.placesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        hidePicker2 = YES;
                    }
                    else{
                        [self.doneView setHidden:YES];
                        [self.picker removeFromSuperview];
                        hidePicker2 = NO;
                    }
                }
                break;
                
            case 2:
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_2_pressed.png"]];
                if(indexPath.row == 0){
                    
                    if(!hideTypeArrDepPicker){
                         
                        self.depArrPickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 150)];
                        selectedPicker = 3;
                        
                        [self.placesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];  
                        self.depArrPickerView.delegate = self;
                        self.depArrPickerView.showsSelectionIndicator = YES;
                        self.depArrPickerView.tag = 3;
                        self.doneView.hidden = NO;
                        self.doneButton.hidden = NO;
                        self.cancelButton.hidden = NO;
                        [self.picker removeFromSuperview];
                        [self.datePicker removeFromSuperview];   
                        [self.view addSubview:self.depArrPickerView];
                        hideTypeArrDepPicker = YES;    
                    }
                    else{
                        [self.doneView setHidden:YES];
                        [self.depArrPickerView removeFromSuperview];
                        [self.depArrPickerView setHidden:YES];
                        hideTypeArrDepPicker = NO;
                    }
                    imageView.image = [UIImage imageNamed:@"cell_top_pressed.png"];
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    cell.backgroundView = imageView;
                }     
                else if(indexPath.row == 1){
                    
                    imageView.image = [UIImage imageNamed:@"cell_bottom_pressed.png"];
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    cell.backgroundView = imageView;
                    [self.depArrPickerView removeFromSuperview];
                    [self.picker removeFromSuperview];
                    selectedPicker = 4;
                    [self showDatePicker:indexPath];
                    if(!hideDatePicker) hideDatePicker = YES;
                    else if(hideDatePicker) {hideDatePicker = NO;
                        [self.doneView setHidden:YES];
                }
                break;
                
            case 3:
                
                [self performSegueWithIdentifier:@"Preferences" sender:self];
                break;
                    
                case 4:
                    if(origin&&destination&&selectedDestinationLocationType&&selectedDate&&selectedOriginLocationType){
                        
                        imageView.image = [UIImage imageNamed:@"btn_find_green_pressed.png"];
                        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                        cell.backgroundView = imageView;
                        if(origin!=destination){
                            [self performSegueWithIdentifier:@"FindRoutes" sender:self];
                        }
                        else
                        {
                            UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start and End Location Cant be Same" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                            [noInternetConnectionAlert show];
                        }
                    }
                    else
                    {   
                        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Missing Details" message:@"Pls Enter the Details" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                        [noInternetConnectionAlert show];
                        
                    }

                    
                    break;
                    
                    
            default:
                break;
        }    
        
    
        }  
    }
}


#pragma mark Picker Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if(pickerView.tag==1){
         selectedOriginLocationType  =[locationTypeData objectAtIndex:row];
    }
    else if(pickerView.tag==2){
        selectedDestinationLocationType  =[locationTypeData objectAtIndex:row];
    }
    else if(pickerView.tag == 3){
        selectedArrDepType = [typeArrDep objectAtIndex:row];
    }
   // [pickerView removeFromSuperview];
    [self.placesTableView reloadData];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(pickerView.tag==1||pickerView.tag==2)
    return [locationTypeData count];
    else
        return [typeArrDep count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if(pickerView.tag==1||pickerView.tag==2)
    return [locationTypeData objectAtIndex:row];
    else
        return [typeArrDep objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


- (IBAction)doneButtonPressed:(id)sender {
     
    [self.picker removeFromSuperview];
    
    switch (selectedPicker) {
        case 1:
           
            hidePicker1 = YES;
            break;
        case 2:
          
            hidePicker2 = YES;
            break;
            
        case 3:
            
            [self.depArrPickerView removeFromSuperview];
            hideTypeArrDepPicker = NO;
            break;
        case 4:
            
            [self.datePicker removeFromSuperview];
            hideDatePicker = NO;
            break;
        default:
            break;
    }
   
    self.doneView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self.depArrPickerView removeFromSuperview];
    [self.picker removeFromSuperview];
    [self.datePicker removeFromSuperview];
    self.doneView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

#pragma mark Date Picker Fucnrtions


-(void)showDatePicker:(NSIndexPath *)indexpaths
{
    if(!hideDatePicker){
        
    self.doneView.hidden = NO;
    self.doneButton.hidden = NO;
    self.cancelButton.hidden = NO;    
    [self.placesTableView scrollToRowAtIndexPath:indexpaths atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    self.datePicker.frame = CGRectMake(0.0, 200, pickerSize.width, 150);
    self.datePicker.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.datePicker];
        [self.datePicker setHidden:NO];
    }
    else {
        [self.datePicker setHidden:YES];
    }
    
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    
    selectedDate = [sender date];


    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:[sender date] toDate:[NSDate date] options:0];
    NSInteger daysBetween = abs([components day]);
       
    if(daysBetween<0){
        
        UIAlertView *dateNotAllowed = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Dates Today or later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [dateNotAllowed show];
    }
    else{
    [self.placesTableView reloadData];
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"FindRoutes"]){
        
        TFLRoutesViewController *routes = [segue destinationViewController];
        routes.fromLocationType = selectedOriginLocationType;
        routes.toLocationType = selectedDestinationLocationType;
        routes.typeArrDep = selectedArrDepType;
        CLLocationCoordinate2D currentLocation = self.mapView.userLocation.coordinate;
        if([origin isEqualToString:@"Current Location"]){
            
            routes.fromLocation = [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",currentLocation.longitude,currentLocation.latitude];
            routes.fromLocationType = @"Coordinate";
            routes.toLocation = destination;
        }
        else if([destination isEqualToString:@"Current Location"]){
            routes.toLocation = [NSString stringWithFormat:@"%f:%f:WGS84[DD.ddddd]",currentLocation.longitude,currentLocation.latitude];
            routes.toLocationType = @"Coordinate";
            routes.fromLocation = origin;
        }
        else{
            routes.fromLocation = origin;
            routes.toLocation = destination;
        }
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:selectedDate];
        
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        
        NSString *itdDateYear;
        
        if(day<10&&month<10){
        
        itdDateYear = [NSString stringWithFormat:@"%d0%d0%d",year,month,day];
        
        }
        else if(day<10){
            itdDateYear = [NSString stringWithFormat:@"%d%d0%d",year,month,day];
            
        }
        else if(month<10){
            
            itdDateYear = [NSString stringWithFormat:@"%d0%d%d",year,month,day];
            
        }
        else
        {
            itdDateYear = [NSString stringWithFormat:@"%d%d%d",year,month,day];
            
        }
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HHmm";
        NSString *dateString = [timeFormatter stringFromDate:selectedDate];
        
        routes.date = itdDateYear;
        routes.time = dateString;
        routes.travelPreferences = travelPreferences;
    }
    
    if([segue.identifier isEqualToString:@"Preferences"]){
        
        TFLPreferencesViewController *preferences = [segue destinationViewController];
        preferences.preferencesDelegate = self;
        
    }
    
}


- (IBAction)handleLongPressGestureRecogniser:(UILongPressGestureRecognizer *)sender {
    
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
        CGPoint point = [sender locationInView:self.view];
        CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.view];
        isLongPressGestureDone = YES;
    
      if(UIGestureRecognizerStateEnded == sender.state) {
        // Do end work here when finger is lifted
         
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        CLLocationCoordinate2D coord = location;
        
        CLLocation *CLlocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        [geocoder reverseGeocodeLocation:CLlocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                return;
            }
            for (CLPlacemark * placemark in placemarks) {
             
                NSLog(@"%@",placemark);
                selectedPlaceName = [placemark name];
                selectedPlaceAddress = [placemark locality];
                NSLog(@"%@",[placemark postalCode]);
                
                selectedLat =[NSString stringWithFormat:@"%f",location.latitude];
                selectedLon =[NSString stringWithFormat:@"%f",location.longitude];
                NSLog(@"Latitude: %f Longitude: %f",[selectedLat doubleValue],[selectedLon doubleValue]);
                
                NSMutableArray *annotations= [[NSMutableArray alloc]init];
                NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
                    
                    [places setObject:selectedPlaceName forKey:@"name"];
                    [places setObject:selectedLat forKey:@"lat"];
                    [places setObject:selectedLon forKey:@"lng"];
                    if(selectedPlaceAddress)
                    [places setObject:selectedPlaceAddress forKey:@"address"];
                                        
                self.placesAnnotation = [placesAnnotations annotationForPlace:places];
                [annotationArray addObject:self.placesAnnotation];
                [annotations addObject:self.placesAnnotation];
                
                self.annotation = annotations; 
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO]; 
                
              }   
        }];
        
       
    }
   
}




- (UIImage *)makeThumbnailOfSize:(CGSize)size withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if(newThumbnail == nil) 
        {
            NSLog(@"could not scale image");
        } 
    return newThumbnail;
}

-(void) sendSelectedPreferences:(NSString *)preferences{
    
    travelPreferences = preferences;
}

@end
