//
//  DLRDetailViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DLRDetailViewController.h"

@implementation DLRDetailViewController

{ 
    NSMutableArray *DLR;
    BOOL *platform;
}
@synthesize departureDLRDetail = _departureDLRDetail;

@synthesize stationName = _stationName;

@synthesize station = _station;

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
    DLR= [[NSMutableArray alloc]init];
    self.title = [NSString stringWithFormat:@"%@ Station",self.station];
    self.departureDLRDetail.delegate = self;
    self.departureDLRDetail.dataSource = self;
    [self.departureDLRDetail setBackgroundColor:[UIColor clearColor]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self FetchXMLData];
}

- (void)viewDidUnload
{
    [self setDepartureDLRDetail:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark FETCHXML Data

- (void) FetchXMLData{
    
    
    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{ 
        
        
        NSString *urlstring = [NSString stringWithFormat:@"http://www.dlrlondon.co.uk/xml/mobile/%@",[NSString stringWithFormat:@"%@.xml",self.stationName]];
        
        NSURL *url = [[NSURL alloc] initWithString:urlstring];
        NSLog(@"%@",url);
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        
        
        xmlParser.delegate = self;
        
        BOOL successInParsingTheXMLDocument = [xmlParser parse];
        
        if(successInParsingTheXMLDocument)
        {
            NSLog(@"No Errors In Parsing ");
        }
        
        dispatch_async(main, ^{
            
          [self.departureDLRDetail reloadData];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
		});
    });
    
    dispatch_release(queue);
    
    
}

#pragma mark NSXML Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([string length]>10){
        [DLR addObject:string];
    }
   
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"ttBoxset"]&&([DLR count]<=0)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Trains" message:@"There Are No Trains For the selected Station" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show]; 
        
    }
}

#pragma mark AlertView Delegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark TableView Delegate Mathods
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    
    // create the button object
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    headerBtn.backgroundColor = [UIColor whiteColor];
    headerBtn.opaque = YES;
    headerBtn.frame = CGRectMake(16.0, 0.0, 320.0, 30.0);
    headerBtn.tag = section;
    [headerBtn setTitle:@"Platform-1" forState:UIControlStateNormal];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerBtn setTitleColor:[UIColor colorWithRed:96.0/255.0 green:111.0/255.0 blue:132.0/255.0 alpha:1.0] forState:UIControlStateNormal];

  headerBtn.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:223.0/255.0 blue:232.0/255.0 alpha:1.0];
    [customView addSubview:headerBtn];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    button.frame = CGRectMake(180.0, 0.0, 240, 30.0);
    [button setImage:[UIImage imageNamed:@"arrowIcon.png"] forState:UIControlStateNormal];
    [customView addSubview:button];
    return customView;
}


-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [DLR count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Platform";
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DLRDetailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DLRDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *name =[[DLR objectAtIndex:indexPath.row]substringFromIndex:2];
    cell.textLabel.text = name;
    
    return cell;
    
}


@end
