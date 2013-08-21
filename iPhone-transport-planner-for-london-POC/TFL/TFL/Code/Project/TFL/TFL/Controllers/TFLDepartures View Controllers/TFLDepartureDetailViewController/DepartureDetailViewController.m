//
//  DepartureDetailViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DepartureDetailViewController.h"

@implementation DepartureDetailViewController
{
    BOOL checkPlatform;
    NSMutableArray *buttonTags;
    NSMutableArray *platformNames;
    NSMutableArray *masterArray;
}

@synthesize searchDepartures = _searchDepartures;
@synthesize statioName = _statioName;
@synthesize data = _data;
@synthesize departureTableView = _departureTableView;

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
    
    self.departureTableView.dataSource = self;
    self.departureTableView.delegate = self;
    self.title = [NSString stringWithFormat:@"%@ Station",self.statioName];
   
    platformNames = [[NSMutableArray alloc]init ];
    self.departureTableView.backgroundColor = [UIColor whiteColor];
    masterArray = [[NSMutableArray alloc]init];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    TFLDepartureDetailModel *departureDeatil = [[TFLDepartureDetailModel alloc]init];
    departureDeatil.searchDepartures = self.searchDepartures;
    departureDeatil.delegate = self;
    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue,^{ 
        [departureDeatil FetchXMLData];
        
        dispatch_async(main, ^{
            
            self.data = masterArray;
		});   
        
    });
    
    dispatch_release(queue);
    
}

-(void) setData:(NSMutableArray *)data{
    
    if(data != _data){
        _data = data;
        [self.departureTableView reloadData];
       
    }
}

- (void)viewDidUnload
{
    [self setDepartureTableView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 55.0)];
    customView.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:223.0/255.0 blue:232.0/255.0 alpha:1.0];
    // create the button object
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
  //  headerBtn.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:223.0/255.0 blue:232.0/255.0 alpha:1.0];
    headerBtn.opaque = YES;
    headerBtn.frame = CGRectMake(15.0, 0.0, 220.0, 30.0);
    headerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [headerBtn setTitle:[platformNames objectAtIndex:section] forState:UIControlStateNormal];
    [headerBtn setTitleColor:[UIColor colorWithRed:96.0/255.0 green:111.0/255.0 blue:132.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [customView addSubview:headerBtn];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    button.frame = CGRectMake(180.0, 0.0, 240, 30.0);
    [button setImage:[UIImage imageNamed:@"arrowIcon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(collapse:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    [customView addSubview:button];
    return customView;
}

- (void) collapse:(UIButton *)button{
   
    
    
    
   if([[buttonTags objectAtIndex:button.tag]isEqualToString:@"0"]){
     
        [buttonTags replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%d",1]];

    }   
    else if([[buttonTags objectAtIndex:button.tag]isEqualToString:@"1"]){
        
       [buttonTags replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%d",0]];
       
    }
  
    [self.departureTableView beginUpdates];
    [self.departureTableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationFade];
    [self.departureTableView endUpdates];
    
}

-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if([[buttonTags objectAtIndex:section] isEqualToString:[NSString stringWithFormat:@"1"]]){
        
        return ([[masterArray objectAtIndex:section] count]-1); 
    }
    else {
        return 0;
    }
     
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [masterArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
        return [platformNames objectAtIndex:section] ;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
       
    DepartureCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartureCell"];
    if (cell == nil) {
        cell = [[DepartureCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartureCell"];
    }
   
   
    cell.atStation.text = [[[masterArray objectAtIndex:[indexPath section]]objectAtIndex:indexPath.row+1]objectForKey:@"at"];
    cell.toStation.text = [[[masterArray objectAtIndex:[indexPath section]]objectAtIndex:indexPath.row+1]objectForKey:@"destination"];
     
        cell.timeToArrive.text = [NSString stringWithFormat:@"%@ MIN",[[[masterArray objectAtIndex:[indexPath section] ]objectAtIndex:indexPath.row+1]objectForKey:@"timeTo"]];

    return cell;
    
}

#pragma mark DepartureDeatilModel Delegate Method

-(void) sendDepartureInfo:(NSMutableArray *)departureInfo andPlatform:(NSMutableArray *)platformInfo{
    
    buttonTags = [[NSMutableArray alloc]init];
    masterArray = departureInfo;
    platformNames = platformInfo;
    
    for (NSInteger count=0 ; count<[platformNames count]; count++) {
        [buttonTags addObject:@"0"];
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}





@end
