//
//  TFLDetailRoutesViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define COMMENT_LABEL_WIDTH 130
#define COMMENT_LABEL_MIN_HEIGHT 50
#define COMMENT_LABEL_PADDING 10

#import "TFLDetailRoutesViewController.h"

@implementation TFLDetailRoutesViewController
{
    NSMutableArray *navigationText;
    NSUInteger indexForNavigation;
    NSMutableArray *transportImagesArray;
    NSInteger selectedIndex ;
    BOOL startEndPinColors;

}
@synthesize routeSummaryTableView = _routeSummaryTableView;
@synthesize route = _route;
@synthesize listView = _listView;
@synthesize mapView_uiView = _mapView_uiView;
@synthesize routesMapView = _routesMapView;
@synthesize navigationView = _navigationView;
@synthesize navigationTextView = _navigationTextView;
@synthesize changeViewButton = _changeViewButton;
@synthesize routeNo = _routeNo;
@synthesize placesAnnotation = _placesAnnotation;
@synthesize transportImageView = _transportImageView;
@synthesize navigationTimeLabel = _navigationTimeLabel;
@synthesize navigationStepNo = _navigationStepNo;
@synthesize annotation =_annotation;

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
    selectedIndex = -1;
    self.routeSummaryTableView.delegate = self;
    self.routeSummaryTableView.dataSource = self;
    self.title = [NSString stringWithFormat:@"%@ Summary",self.routeNo];
    navigationText = [[NSMutableArray alloc]init];
    
    meansOfTransport = [[NSMutableArray alloc]initWithObjects:@"Train",@"Commuter railway",@"Underground",@"City rail",@"Tram",@"City bus",@"Regional bus",@"Coach",@"Cable car",@"Boat",@"Transit on demand",nil];
    
    self.routesMapView.showsUserLocation = YES;
    self.routesMapView.delegate = self;
    indexForNavigation = 1;
    
    transportImagesArray = [[NSMutableArray alloc]init];
    [self.changeViewButton setImage:[UIImage imageNamed:@"btn_map_normal.png"] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setRouteSummaryTableView:nil];
    [self setListView:nil];
    [self setMapView_uiView:nil];
    [self setRoutesMapView:nil];
    [self setNavigationView:nil];
    [self setNavigationTextView:nil];
    [self setTransportImageView:nil];
    [self setNavigationTimeLabel:nil];
    [self setNavigationStepNo:nil];
    [self setChangeViewButton:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark tableView Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    RouteSummaryCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeSummaryCell"];
    
    if (cell == nil) {
        cell = [[RouteSummaryCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"routeSummaryCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    
    //If this is the selected index then calculate the height of the cell based on the amount of text we have
    if(selectedIndex == indexPath.row)
    {
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
        
        cell.stepsMessage.frame = CGRectMake(cell.stepsMessage.frame.origin.x, 
                                                 cell.stepsMessage.frame.origin.y, 
                                                 cell.stepsMessage.frame.size.width, 
                                                 labelHeight-25);
        
        cell.cellBottomImageView.frame = CGRectMake(cell.bounds.origin.x+26, cell.bounds.origin.y+52, 285.0, labelHeight-25);
        
        cell.cellStripImageView.frame = CGRectMake(cell.bounds.origin.x+8, cell.bounds.origin.y+43,4.0,labelHeight - 25);
        
    }
    else {
        
        //Otherwise just return the minimum height for the label.
        cell.stepsMessage.frame = CGRectMake(cell.stepsMessage.frame.origin.x, 
                                                 cell.stepsMessage.frame.origin.y, 
                                                 cell.stepsMessage.frame.size.width, 
                                                 COMMENT_LABEL_MIN_HEIGHT);
        
        cell.cellBottomImageView.frame = CGRectMake(cell.bounds.origin.x+26, cell.bounds.origin.y+52, 285.0, 61.0);
        
        
        cell.cellStripImageView.frame = CGRectMake(cell.bounds.origin.x+8, cell.bounds.origin.y+43,4.0,86.0);
    }
    
    
    
    
    
    cell.stepNo.text =[NSString stringWithFormat:@"%d",(indexPath.row)+1];
    NSString *message;
    NSDictionary *routeDict = [[NSDictionary alloc]initWithDictionary:[[self.route objectForKey:@"partialRoutes"] objectAtIndex:indexPath.row]];
    
    
    if([[routeDict objectForKey:@"transportType"] isEqualToString:@"100"]||[[routeDict objectForKey:@"transportType"] isEqualToString:@"99"]){
        
        message = [NSString stringWithFormat:@"Walk from %@ to %@",[routeDict objectForKey:@"From"],[[[self.route objectForKey:@"partialRoutes"] objectAtIndex:indexPath.row] objectForKey:@"To"]];
        
            NSLog(@"1:%@",message);
    }
    else if([[routeDict objectForKey:@"transportType"] isEqualToString:@"107"]){
       
        message = [NSString stringWithFormat:@"Ride Cycle from %@ to %@",[routeDict objectForKey:@"From"],[routeDict objectForKey:@"To"]];
    }
    
    else if([meansOfTransport objectAtIndex:[[routeDict objectForKey:@"transportType"] integerValue]]){
        
         message = [NSString stringWithFormat:@"Take "];
    }

   

    
        
    NSInteger i;
        
    for (i=0; i<[[routeDict objectForKey:@"transportInfo"]count]; i++) {
            
        if(i!=0){
                message = [NSString stringWithFormat:@"%@ (or) Take ",message];
        }
        if ([[[[routeDict objectForKey:@"transportInfo"]objectAtIndex:i]objectForKey:@"destination"] length]>0) {
            
            message = [NSString stringWithFormat:@"%@ %@ from %@ to %@ ",message,[[[routeDict objectForKey:@"transportInfo"]objectAtIndex:i]objectForKey:@"transportName"],[[[self.route objectForKey:@"partialRoutes"] objectAtIndex:indexPath.row] objectForKey:@"From"],[[[routeDict objectForKey:@"transportInfo"]objectAtIndex:i]objectForKey:@"destination"]];
        }
        
         
        }
    
    NSLog(@"2:%@",message);
    
    NSString *imagePath = [routeDict objectForKey:@"transportType"];
    
    cell.transportImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"route_%@.png",imagePath]];
    
    if (imagePath == (id)[NSNull null] || imagePath.length == 0 ) imagePath = @"route_7.png";
    else
    {

        [transportImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"route_%@.png",imagePath]]];

    }
       
    NSString *time = [NSString stringWithFormat:@"%@ : %@" ,[routeDict objectForKey:@"partialRouteHour1"],[routeDict objectForKey:@"partialRouteMinute1"]];
    
    if(indexPath.row==0){
            time = [NSString stringWithFormat:@"Start %@",time];
    }
    
    cell.time.text = time;
    cell.stepsMessage.text = message;
    if ([message length]>0) {
        [navigationText addObject:message];
    }
    
    
    return cell;   
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.route objectForKey:@"partialRoutes"] count];
    
}

- (IBAction)changeViewButtonPressed:(id)sender {
    
    if (checkChangeViewButton == NO) {
        [self.changeViewButton setImage:[UIImage imageNamed:@"btn_list_normal.png"] forState:UIControlStateNormal];
        checkChangeViewButton = YES;
    }
    else
    {
        [self.changeViewButton setImage:[UIImage imageNamed:@"btn_map_normal.png"] forState:UIControlStateNormal];
        checkChangeViewButton = NO;
    }
    
    [self.routesMapView setHidden:[self.listView isHidden]];
    [self.listView setHidden:![self.routesMapView isHidden]];
    [self drawPolyline:self.route];
}

-(void) drawPolyline:(NSMutableDictionary *)coordinateData {
    
    NSInteger i,j;
    CLLocationCoordinate2D coordinate;
    
    for (i=0; i<[[coordinateData objectForKey:@"partialRoutes"] count]; i++) {
        
        NSInteger count = [[[[coordinateData objectForKey:@"partialRoutes"]objectAtIndex:i]objectForKey:@"coordinates"] count];
        CLLocationCoordinate2D coordinates[count];
        NSArray *partialRoute = [[NSArray alloc]initWithArray:[[[coordinateData objectForKey:@"partialRoutes"]objectAtIndex:i]objectForKey:@"coordinates"]];
        for (j=0; j<count ;j++) {
            
            NSString *longitude = [NSString stringWithFormat:@"%@",[[partialRoute objectAtIndex:j]objectForKey:@"x"]];
            NSString *latitude =  [NSString stringWithFormat:@"%@",[[partialRoute objectAtIndex:j]objectForKey:@"y"]];
            coordinate.latitude = [latitude doubleValue];
            coordinate.longitude = [longitude doubleValue];
            coordinates[j] = coordinate;
        }
       
        polyLine = [MKPolyline polylineWithCoordinates:coordinates count:count];
        [self.routesMapView addOverlay:polyLine];
        
    }
    NSDictionary *routeDict = [[NSDictionary alloc]initWithDictionary:[[self.route objectForKey:@"partialRoutes"] objectAtIndex:0]];
    NSString *time = [NSString stringWithFormat:@"%@ : %@" ,[routeDict objectForKey:@"partialRouteHour1"],[routeDict objectForKey:@"partialRouteMinute1"]];
    self.navigationTimeLabel.text = time;
    
    NSMutableArray *annotations= [[NSMutableArray alloc]init];
    NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
    
    [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"] forKey:@"lat"];
    [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"] forKey:@"lng"];
    self.placesAnnotation = [placesAnnotations annotationForPlace:places];
    [annotations addObject:self.placesAnnotation];
    self.annotation = annotations; 
    
    [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]lastObject]objectForKey:@"coordinates"]lastObject]objectForKey:@"y"] forKey:@"lat"];
    [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]lastObject]objectForKey:@"coordinates"]lastObject]objectForKey:@"x"] forKey:@"lng"];
    self.placesAnnotation = [placesAnnotations annotationForPlace:places];
    [annotations addObject:self.placesAnnotation];
    self.annotation = annotations; 

    
    MKCoordinateSpan span;
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    MKCoordinateRegion region;
    region.span=span;
    region.center=CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue] ,[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"]doubleValue]);
    [self.routesMapView setRegion:region animated:YES];
    [self.routesMapView regionThatFits:region];
    if ([navigationText count]>0) {
        self.navigationTextView.text = [navigationText objectAtIndex:0];  
    }
   
    self.transportImageView.image= [transportImagesArray objectAtIndex:0];
    self.navigationStepNo.text = [NSString stringWithFormat:@"Step %d of %d",indexForNavigation,[[self.route objectForKey:@"partialRoutes"] count]];
}

#pragma mark MapsOverlay Properties

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor blueColor];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 5.0;
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        return circleView;
    }
    else{
        return polylineView;
    }
    
}


- (IBAction)backNavigationButtonPressed:(id)sender {
    
    startEndPinColors = YES;

    
    if ([[self.route objectForKey:@"partialRoutes"] count] == 1) {
        MKCoordinateSpan span;
        span.latitudeDelta=0.05;
        span.longitudeDelta=0.05;
        MKCoordinateRegion region;
        region.span=span;
        region.center=CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue],[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"]doubleValue]);
        
        
        
        [self.routesMapView setRegion:region animated:YES];
        [self.routesMapView regionThatFits:region];
    }
    
   else if(indexForNavigation>0){
        
         if([[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"] != nil){
        indexForNavigation--;
             if(indexForNavigation < [transportImagesArray count])
             {
                 self.transportImageView.image = [transportImagesArray objectAtIndex:indexForNavigation];     
             }
        NSMutableArray *annotations= [[NSMutableArray alloc]init];
        NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
        [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"] forKey:@"lat"];
        [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"] forKey:@"lng"];
        
        [self.routesMapView removeOverlay:circle];
        circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue],[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"] doubleValue]) radius:100];
        [self.routesMapView addOverlay:circle];      
             
        self.placesAnnotation = [placesAnnotations annotationForPlace:places];
        [annotations addObject:self.placesAnnotation];
        self.annotation = annotations; 
       
             NSDictionary *routeDict = [[NSDictionary alloc]initWithDictionary:[[self.route objectForKey:@"partialRoutes"] objectAtIndex:indexForNavigation]];
             NSString *time = [NSString stringWithFormat:@"%@ : %@" ,[routeDict objectForKey:@"partialRouteHour1"],[routeDict objectForKey:@"partialRouteMinute1"]];
             self.navigationTimeLabel.text = time;
             self.navigationStepNo.text = [NSString stringWithFormat:@"Step %d of %d",indexForNavigation+1,[[self.route objectForKey:@"partialRoutes"] count]];
             
        MKCoordinateSpan span;
        span.latitudeDelta=0.05;
        span.longitudeDelta=0.05;
        MKCoordinateRegion region;
        region.span=span;
        
        region.center=CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue] ,[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"]doubleValue]);
        [self.routesMapView setRegion:region animated:YES];
        [self.routesMapView regionThatFits:region];
             if(indexForNavigation < [navigationText count]){
                 self.navigationTextView.text = [navigationText objectAtIndex:indexForNavigation];
             }
        }     
        
    }

    
}
- (IBAction)forwardNavigationButtonPressed:(id)sender {

    startEndPinColors = YES;

        
    if ([[self.route objectForKey:@"partialRoutes"] count] == 1) {
        MKCoordinateSpan span;
        span.latitudeDelta=0.05;
        span.longitudeDelta=0.05;
        MKCoordinateRegion region;
        region.span=span;
        region.center=CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]lastObject]objectForKey:@"coordinates"]lastObject]objectForKey:@"y"]doubleValue],[[[[[[self.route objectForKey:@"partialRoutes"]lastObject]objectForKey:@"coordinates"]lastObject]objectForKey:@"x"]doubleValue]);
        [self.routesMapView setRegion:region animated:YES];
        [self.routesMapView regionThatFits:region];
    }
    
    if(indexForNavigation<[[self.route objectForKey:@"partialRoutes"] count]){

    NSMutableArray *annotations= [[NSMutableArray alloc]init];
    NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
        if([[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"] != nil){
            if(indexForNavigation < [transportImagesArray count])
            {
                if ([transportImagesArray objectAtIndex:indexForNavigation]) {
                    self.transportImageView.image = [transportImagesArray objectAtIndex:indexForNavigation];
                    }
            }
            
            [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"] forKey:@"lat"];
            [places setObject:[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"] forKey:@"lng"];
            
            [self.routesMapView removeOverlay:circle];
            circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue],[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"] doubleValue]) radius:100];
            [self.routesMapView addOverlay:circle];
            
            self.placesAnnotation = [placesAnnotations annotationForPlace:places];
            [annotations addObject:self.placesAnnotation];
            self.annotation = annotations; 
            
            NSDictionary *routeDict = [[NSDictionary alloc]initWithDictionary:[[self.route objectForKey:@"partialRoutes"] objectAtIndex:indexForNavigation]];
            NSString *time = [NSString stringWithFormat:@"%@ : %@" ,[routeDict objectForKey:@"partialRouteHour1"],[routeDict objectForKey:@"partialRouteMinute1"]];
            self.navigationTimeLabel.text = time;
            self.navigationStepNo.text = [NSString stringWithFormat:@"Step %d of %d",indexForNavigation+1,[[self.route objectForKey:@"partialRoutes"] count]];
            
            MKCoordinateSpan span;
            span.latitudeDelta=0.05;
            span.longitudeDelta=0.05;
            MKCoordinateRegion region;
            region.span=span;
            region.center=CLLocationCoordinate2DMake([[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"y"]doubleValue],[[[[[[self.route objectForKey:@"partialRoutes"]objectAtIndex:indexForNavigation]objectForKey:@"coordinates"]objectAtIndex:0]objectForKey:@"x"]doubleValue]);
            [self.routesMapView setRegion:region animated:YES];
            [self.routesMapView regionThatFits:region];
            if(indexForNavigation<[navigationText count]){
            self.navigationTextView.text = [navigationText objectAtIndex:indexForNavigation];
            }
 
        }
        
    
        if(indexForNavigation<[[self.route objectForKey:@"partialRoutes"]count]-1){
            indexForNavigation++;
    }  
  }
    
}

#pragma mark MapView Methods

- (void) updateMapView
{
    [self.routesMapView addAnnotations:_annotation];
}

-(void) setMapView:(MKMapView *)mapView{
    
    _routesMapView = mapView;
    [self performSelectorOnMainThread:@selector(updateMapView) withObject:nil waitUntilDone:YES];
}

-(void) setAnnotation:(NSMutableArray *)annotation{
    
    _annotation = annotation;
    [self performSelectorOnMainThread:@selector(updateMapView) withObject:nil waitUntilDone:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    MKPinAnnotationView *pinView = nil; 
    static NSString *defaultPinID = @"Route Pin";
    pinView = (MKPinAnnotationView *)[self.routesMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                     initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    if (startEndPinColors) {
        pinView.pinColor = MKPinAnnotationColorGreen; 
    }
    else{
        pinView.pinColor = MKPinAnnotationColorRed; 
    }
    
    pinView.canShowCallout = NO;
    pinView.animatesDrop = NO;
    return pinView;
}

#pragma mark TableView Expanding

-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, CGFLOAT_MAX);
    
    CGSize labelHeighSize = [[navigationText objectAtIndex:index] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
                                                        constrainedToSize:maximumSize
                                                            lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row)
    {
        return [self getLabelHeightForIndex:indexPath.row] + 30;
    }
    else {
        return COMMENT_LABEL_MIN_HEIGHT + 80;
    }
}


-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //We only don't want to allow selection on any cells which cannot be expanded
    if([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT)
    {
        return indexPath;
    }
    else {
        return nil;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end
