//
//  TFLRoutesViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 17/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLRoutesViewController.h"

#define placeOfInterest @"poi"
#define stop @"stop"
#define postCode @"locator"
#define address @"address"
#define coordinate @"coord"
#define Departure @"dep"
#define Arrival @"arr"

#define TFL_TESTPreferences @"http://jpapi.tfl.gov.uk/api/XML_TRIP_REQUEST2?execInst=normal&ptAdvancedOptions=1&trITMOTvalue=20&advOpt_2=1&type_destination=poi&itdDate=20120813&coordOutputFormat=WGS84%5BDD.DDDDD%5D&calculateDistance=1&place_origin=London&ptOptionsActive=1&place_destination=London&itdTime=1436&routeType=leasttime&sessionID=0&itOptionsActive=1&itdTripDateTimeDepArr=dep&name_origin=Tate+Britain+Gallery%2C+Westminster&advOptActive_2=1&name_destination=BRITISH+MUSEUM&language=en&stepfree-access=no-requirements&changeSpeed=100&trITMOT=100&imparedOptionsActive=1&type_origin=poi"

#define TFL_URL @"http://jpapi.tfl.gov.uk/api/XML_TRIP_REQUEST2?language=en&sessionID=0&place_origin=London&type_origin=stop&name_origin=Alexander%20Road&coordOutputFormat=WGS84%5BDD.DDDDD%5D&place_destination=London&type_destination=stop&name_destination=Prince%20Of%20Wales%20Gate&itdDate=20121022&itdTime=0800"
#define TFL @"http://192.168.16.36:3000/journey_planners/search_route_options?urlString=http://jpapi.tfl.gov.uk/api/XML_TRIP_REQUEST2?sessionID=0&type_destination=poi&itdDate=20120727&name_origin=marylebone&coordOutputFormat=WGS84%5BDD.DDDDD%5D&name_destination=BRITISH+MUSEUM&language=en&place_origin=London&place_destination=London&type_origin=poi&itdTime=0958"

@implementation TFLRoutesViewController{
    
    BOOL checkRoutes;
    BOOL checkTime;
    BOOL checkMin;
    BOOL checkPaths;
    BOOL checkFirstTime;
    BOOL checkPartialTime;
    BOOL checkPartialRouteName;
    BOOL checkPartial_Names;
    BOOL checkCoordinates;
    BOOL checkX;
    BOOL checkY;
    BOOL checkIfRoutesExist;
    BOOL checkMeansOfTransport;
   
    NSMutableArray *routesInfo;
    NSMutableArray *partialRoutesInfo;
    NSMutableDictionary *routesDict;
    NSMutableDictionary *partialRoutesDict;
    NSMutableDictionary *transportDict;
    NSMutableArray *transportInfo;
    NSMutableDictionary *coordinateDict;
    NSMutableArray *coordinateInfo;
    NSMutableData *xmldata;
    NSMutableArray *selectedRoute;
    NSString *url ;
    NSString *routeNo;
    
    NSInteger routeListException;
    
}

@synthesize routesTableView = _routesTableView;

@synthesize fromLocation = _fromLocation;
@synthesize fromLocationType = _fromLocationType;
@synthesize toLocation = _toLocation;
@synthesize toLocationType = _toLocationType;
@synthesize date= _date;
@synthesize time = _time;
@synthesize typeArrDep = _typeArrDep;
@synthesize travelPreferences = _travelPreferences;

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
    routeListException = 0;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [[ProgressHUD defaultHUD] showInView:self.view];
   
    [self checkForLocationType];
    
    NSString *urlEncoded =[NSString stringWithFormat:@"http://jpapi.tfl.gov.uk/api/XML_TRIP_REQUEST2?language=en&sessionID=0&place_origin=London&type_origin=%@&name_origin=%@&coordOutputFormat=WGS84[DD.ddddd]&place_destination=London&type_destination=%@&name_destination=%@&itdDate=%@&itdTime=%@",self.fromLocationType,self.fromLocation,self.toLocationType,self.toLocation,self.date,self.time];
    
    if(self.typeArrDep){
        
        urlEncoded = [NSString stringWithFormat:@"%@&itdTripDateTimeDepArr=%@",urlEncoded,self.typeArrDep];
    }
    if (self.travelPreferences) {
        urlEncoded = [NSString stringWithFormat:@"%@%@",urlEncoded,self.travelPreferences];
    }
    url = [urlEncoded stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSLog(@"%@",url);
  
    routesInfo = [[NSMutableArray alloc]init];
    routesDict = [[NSMutableDictionary alloc]init];
    partialRoutesDict = [[NSMutableDictionary alloc]init];
    partialRoutesInfo = [[NSMutableArray alloc]init];
    selectedRoute = [[NSMutableArray alloc]init];
    transportInfo = [[NSMutableArray alloc]init];
    transportDict = [[NSMutableDictionary alloc]init];
    coordinateDict = [[NSMutableDictionary alloc]init];
    coordinateInfo = [[NSMutableArray alloc]init];
  
    self.routesTableView.delegate = self;
    self.routesTableView.dataSource = self;
    xmldata = [[NSMutableData alloc]init];
    
    [self FetchXMLData];
}

- (void)viewDidUnload
{
    [self setRoutesTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) checkForLocationType{
    
    if([self.fromLocationType isEqualToString:@"Stop"]){
        
        self.fromLocationType = stop; 
    }
    else if([self.fromLocationType isEqualToString:@"Address"]){
        
        self.fromLocationType = address; 
    }
    else if([self.fromLocationType isEqualToString:@"PostCode"]){
        
        self.fromLocationType = postCode;
    }
    else if([self.fromLocationType isEqualToString:@"Place Of Interest"]){
        
        self.fromLocationType = placeOfInterest;
    }
    
    else if([self.fromLocationType isEqualToString:@"Coordinate"]){
        self.fromLocationType = coordinate;
    }
    
    
    if([self.toLocationType isEqualToString:@"Stop"]){
        
        self.toLocationType = stop; 
    }
    else if([self.toLocationType isEqualToString:@"Address"]){
        
        self.toLocationType = address; 
    }
    else if([self.toLocationType isEqualToString:@"PostCode"]){
        
        self.toLocationType = postCode;
    }
    else if([self.toLocationType isEqualToString:@"Place Of Interest"]){
        
        self.toLocationType = placeOfInterest;
    }
    else if([self.toLocationType isEqualToString:@"Coordinate"]){
        self.toLocationType = coordinate;
    }
    
    if([self.typeArrDep isEqualToString:@"Departure"]){
        self.typeArrDep = Departure;
    }
    else if([self.typeArrDep isEqualToString:@"Arrival"]){
        self.typeArrDep = Arrival;
    }
}

- (void) FetchXMLData{
        
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        
    }
    else {
    //Inform User Connection Failed
    }

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmldata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[xmldata length]);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmldata];
        
            xmlParser.delegate = self;
       
            BOOL successInParsingTheXMLDocument = [xmlParser parse];
        
            if(successInParsingTheXMLDocument)
            {
                NSLog(@"No Errors In Parsing ");
            }
            else
            {
    			UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Unable to retrieve data.An Internet Connection is required." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Learn More", nil];
    			[noInternetConnectionAlert show];
            }
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
    if([elementName isEqualToString:@"itdRoute"]){
        
        checkTime = YES;
        checkFirstTime = YES;
        checkIfRoutesExist= YES;
        [routesDict setObject:[NSString stringWithFormat:@"Route-%@",[attributeDict objectForKey:@"routeTripIndex"]] forKey:@"routeIndex"];
        [routesDict setObject:[attributeDict objectForKey:@"publicDuration"] forKey:@"routeDuration"];
               
    }
    if([elementName isEqualToString:@"itdTime"]&&checkTime){
        
        
        if(checkMin){
            [routesDict setObject:[attributeDict objectForKey:@"hour"] forKey:@"e_hour"];
            [routesDict setObject:[attributeDict objectForKey:@"minute"] forKey:@"e_minute"];
        }
       
        else{
        [routesDict setObject:[attributeDict objectForKey:@"hour"] forKey:@"s_hour"];
        [routesDict setObject:[attributeDict objectForKey:@"minute"] forKey:@"s_minute"];
         checkMin = YES;
        }
    }
    else if([elementName isEqualToString:@"itdTime"]&&!checkTime&&!checkPaths&&checkFirstTime){
        
        if(!checkPartialTime){
        [partialRoutesDict setObject:[attributeDict objectForKey:@"hour"] forKey:@"partialRouteHour1"];
        [partialRoutesDict setObject:[attributeDict objectForKey:@"minute"] forKey:@"partialRouteMinute1"];
            checkPartialTime =YES;
        }
        else{
            [partialRoutesDict setObject:[attributeDict objectForKey:@"hour"] forKey:@"partialRouteHour2"];
            [partialRoutesDict setObject:[attributeDict objectForKey:@"minute"] forKey:@"partialRouteMinute2"];  
             checkPartialTime =NO;
        }
    }
    
    
    if([elementName isEqualToString:@"itdInterchangePathCoordinates"]){
        
        checkCoordinates = YES;
       
        
    }
    
    if([elementName isEqualToString:@"x"]&&!checkCoordinates){
       
        checkX = YES;
    }
    if([elementName isEqualToString:@"y"]&&!checkCoordinates){
        
        checkY = YES;
    }
    
    if([elementName isEqualToString:@"itdPoint"]&&checkPartialRouteName){
        
        if(!checkPartial_Names){
            
            if([attributeDict objectForKey:@"name"]){
            [partialRoutesDict setObject:[attributeDict objectForKey:@"name"] forKey:@"From"];
            checkPartial_Names = YES;
            }
        }
        else{
            
            if([attributeDict objectForKey:@"name"]){
            [partialRoutesDict setObject:[attributeDict objectForKey:@"name"] forKey:@"To"];
            checkPartial_Names = NO;
            }
        }
    }
    
    if([elementName isEqualToString:@"itdStopSeq"]){
        
        checkPaths =YES;
        checkPartialRouteName = NO;
    }
    
    
    if([elementName isEqualToString:@"itdPartialRoute"]){
        checkMeansOfTransport = YES;
        checkTime = NO;
        checkPartialRouteName = YES;
        [partialRoutesDict setObject:[attributeDict objectForKey:@"timeMinute"] forKey:@"partialRouteDuration"];
    }
    
    if([elementName isEqualToString:@"itdMeansOfTransportList"]){
        checkRoutes = YES;
    
    }
    
    if([elementName isEqualToString:@"itdMeansOfTransport"]){
        
//        if ([[attributeDict objectForKey:@"motType"]integerValue] < 11) {
//            
//            [transportDict setObject:[attributeDict objectForKey:@"name"] forKey:@"transportName"];
//            [transportDict setObject:[attributeDict objectForKey:@"destination"] forKey:@"destination"];
//            
//            NSLog(@"%d",[[attributeDict objectForKey:@"motType"]integerValue]);
//        }
        
        
        if(checkMeansOfTransport){
            [transportDict setObject:[attributeDict objectForKey:@"name"] forKey:@"transportName"];
            [transportDict setObject:[attributeDict objectForKey:@"destination"] forKey:@"destination"];
            checkMeansOfTransport = NO;
        }
       
        
        if(checkRoutes){
           
            if([attributeDict objectForKey:@"name"]){
                
                if (![[[transportInfo lastObject]objectForKey:@"destination"] isEqualToString:[attributeDict objectForKey:@"destination"]]) {
                    
                    [transportDict setObject:[attributeDict objectForKey:@"name"] forKey:@"transportName"];
                    [transportDict setObject:[attributeDict objectForKey:@"destination"] forKey:@"destination"];
                }
                    
                    
            
            }
            
        }
        
        else{
            
            if([attributeDict objectForKey:@"motType"]){
                [partialRoutesDict setObject:[attributeDict objectForKey:@"motType"] forKey:@"transportType"];
              
            }
            else if([attributeDict objectForKey:@"type"]){
                [partialRoutesDict setObject:[attributeDict objectForKey:@"type"] forKey:@"transportType"];
            }
        }
    
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(checkX){
        
        if([string length]>0){
        [coordinateDict setObject:string forKey:@"x"];
        checkX = NO;
        }
    }
    if(checkY){
        
        if([string length]>0){
        [coordinateDict setObject:string forKey:@"y"];
         checkY = NO;
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"itdRoute"]){
       
        [routesDict setObject:[partialRoutesInfo mutableCopy] forKey:@"partialRoutes"];
        [partialRoutesInfo removeAllObjects];
        
        [routesInfo addObject:[routesDict mutableCopy]];
        
        [routesDict removeAllObjects];
        
        checkTime = NO;
        checkMin = NO;
      
        
    }
    
    if([elementName isEqualToString:@"itdInterchangePathCoordinates"]){
        
        checkCoordinates = NO;
        
    }
    if([elementName isEqualToString:@"itdCoordinateBaseElem"]){
        
        if([coordinateDict count]==2){
        [coordinateInfo addObject:[coordinateDict mutableCopy]];
        [coordinateDict removeAllObjects];
        }
    }
    
    if([elementName isEqualToString:@"itdMeansOfTransport"]){
        
      
        if([transportDict count]==2){
        [transportInfo addObject:[transportDict mutableCopy]] ;
        [transportDict removeAllObjects];
        }
    }
    
    if([elementName isEqualToString:@"itdMeansOfTransportList"]){
     
       //this is where test case changed.. 
       
    }
    
    if([elementName isEqualToString:@"itdStopSeq"]){
        
        checkPaths =NO;
    }
    
    if([elementName isEqualToString:@"itdPartialRoute"]){
        
       
        checkRoutes = NO;
        checkPartialRouteName = NO;
       
        [partialRoutesDict setObject:[transportInfo mutableCopy] forKey:@"transportInfo"];
        [transportInfo removeAllObjects];
        
        
        
        [partialRoutesDict setObject:[coordinateInfo mutableCopy] forKey:@"coordinates"];
        [coordinateInfo removeAllObjects];
        [partialRoutesInfo addObject:[partialRoutesDict mutableCopy]];
        [partialRoutesDict removeAllObjects];
   }
        
  if([elementName isEqualToString:@"itdRouteList"]){
      [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [[ProgressHUD defaultHUD] hideActivityIndicator];
        [self.routesTableView reloadData];
    }
    
    if([elementName isEqualToString:@"itdItinerary"]){
        if(!checkIfRoutesExist){
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            [[ProgressHUD defaultHUD] hideActivityIndicator];
            UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Routes" message:@"Sorry Data Not Found" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [noInternetConnectionAlert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSLog(@"%@",routesInfo); 
    }
}

#pragma mark TableView Delegate Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [routesInfo count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    RoutesDisplayCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routesCell"];
    if (cell == nil) {
        cell = [[RoutesDisplayCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"routesCell"];
              
    }
  
      
    [cell.contentView setClearsContextBeforeDrawing:YES];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    cell.route.text = [NSString stringWithFormat:@"Route %d",(indexPath.row+1)];
    cell.travelTime.text = [NSString stringWithFormat:@"%@",[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"routeDuration"]];
    cell.backgroundColor = [UIColor clearColor];
   
    NSInteger imageCount,distanceToBeMoved=0;
    NSInteger maxImages = [[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"] count];
    
   
    
    NSArray *routeData = [[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"];

    for (imageCount=0; imageCount<maxImages; imageCount++) {
        
        
        [cell.contentView setClearsContextBeforeDrawing:YES];
        NSString *imagePath = [[routeData objectAtIndex:imageCount]objectForKey:@"transportType"];
        UIImageView *transportImageView ;
        transportImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+distanceToBeMoved,110, 20, 20)];
        transportImageView.tag = 100;   //Added a unique tag jus to avoid replication while Reusing cells
        transportImageView.image= [UIImage imageNamed:[NSString stringWithFormat:@"route_%@.png",imagePath]];    
        [cell.contentView addSubview:transportImageView];
        distanceToBeMoved = distanceToBeMoved+30;
    }
    

   
    if([[routesInfo objectAtIndex:indexPath.row]objectForKey:@"s_hour"]){
  
        cell.startTime.text = [[routesInfo objectAtIndex:indexPath.row]objectForKey:@"s_hour"]; 
        
        if([[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"s_minute"] length]<2){
            
            cell.startMin.text = [NSString stringWithFormat:@"0%@",[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"s_minute"]];
        }
        else{
            cell.startMin.text = [[routesInfo objectAtIndex:indexPath.row]objectForKey:@"s_minute"];
        }
        
        cell.endTime.text = [[routesInfo objectAtIndex:indexPath.row]objectForKey:@"e_hour"];
        
        if([[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"e_minute"] length]<2){
            cell.endMin.text =[NSString stringWithFormat:@"0%@",[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"e_minute"]];
        }
        else{
            cell.endMin.text = [[routesInfo objectAtIndex:indexPath.row]objectForKey:@"e_minute"];
        }
    }
    else{
        
        if ([[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"] count]==1) {
            
            cell.startTime.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"partialRouteHour1"];
            cell.endTime.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]lastObject]objectForKey:@"partialRouteHour2"];
            cell.startMin.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"partialRouteMinute1"];
            cell.endMin.text =[[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]lastObject]objectForKey:@"partialRouteMinute2"] ;
            
        }
        else{
        cell.startTime.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"partialRouteHour2"];
        cell.endTime.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]lastObject]objectForKey:@"partialRouteHour2"];
        cell.startMin.text = [[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]objectAtIndex:0]objectForKey:@"partialRouteMinute2"];
        cell.endMin.text =[[[[routesInfo objectAtIndex:indexPath.row]objectForKey:@"partialRoutes"]lastObject]objectForKey:@"partialRouteMinute2"] ;
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    routeNo = [NSString stringWithFormat:@"Route:%d",(indexPath.row+1)];
    selectedRoute = [[routesInfo objectAtIndex:indexPath.row] mutableCopy];
    [self performSegueWithIdentifier:@"DetailRoute" sender:self];
    
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"DetailRoute"]){
       
        TFLDetailRoutesViewController *detailRoute = [segue destinationViewController];
        detailRoute.route = [selectedRoute mutableCopy];
        detailRoute.routeNo = routeNo;
    }
}

@end
