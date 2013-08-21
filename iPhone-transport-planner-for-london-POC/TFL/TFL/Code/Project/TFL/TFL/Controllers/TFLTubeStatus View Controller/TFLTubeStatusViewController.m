//
//  TFLSecondViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLTubeStatusViewController.h"



#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@implementation TFLTubeStatusViewController
{
    NSString *headerText;
    NSMutableArray *tubeColors;
    NSInteger messageIndex;
    NSInteger messageIndexForWeekend;
    NSDate *selectedDate;
    NSString *diffInDate;
    NSMutableString *itemString;
    NSMutableArray *messageArray;
    NSMutableArray *tubeName;
    NSString *selectedDateInString;
    NSMutableArray *tubeStatusCopy;
    NSMutableArray *tubeStatusLater;
    NSMutableArray *tubeStatusWeekEnd;   
    UIDatePicker* picker;
}

@synthesize nowButton;
@synthesize laterButton;
@synthesize weekEndButton;
@synthesize name = _name;
@synthesize messagePopupView = _messagePopupView;
@synthesize laterStatusView;
@synthesize weekEndStatusView;
@synthesize mainView = _mainView;
@synthesize textView = _textView;
@synthesize backgroundView;
@synthesize tubeStatusTableView;
@synthesize laterStatusTableView;
@synthesize weekEndStatusTableView;
@synthesize refreshView = _refreshView;
@synthesize doneView;
@synthesize doneButton;
@synthesize cancelButton;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(void) sendTubeStatus:(NSMutableArray *)tubeStatusData{
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
   
    
    [tubeStatusCopy removeAllObjects];
    tubeStatusCopy = [tubeStatusData mutableCopy];
    
   
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if( [CheckNetwork isConnectedToNetwork]){
        headerText = @"Today";
        self.backgroundView.hidden = YES;
        self.doneView.hidden = YES;
        self.doneButton.hidden = YES;
        self.cancelButton.hidden = YES;
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        
        
        tubeStatusCopy = [[NSMutableArray alloc]init];  
        self.tubeStatusTableView.delegate = self;
        self.tubeStatusTableView.dataSource = self;
        self.weekEndStatusTableView.dataSource =self;
        self.weekEndStatusTableView.delegate = self;
        self.laterStatusTableView.delegate =self;
        self.laterStatusTableView.dataSource =self;
        self.textView.backgroundColor = [UIColor clearColor];
        [self.textView setEditable:NO];
        tubeColors = [[NSMutableArray alloc]init];
        tubeStatusWeekEnd = [[NSMutableArray alloc]init];
        tubeStatusLater = [[NSMutableArray alloc]init];
        TFLTubeStatusModel *tubeStatus = [[TFLTubeStatusModel alloc]init];
        tubeStatus.delegate = self;
        tubeStatus.statusFor = @"Today";
        
        self.nowButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
        self.nowButton.titleLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        self.laterButton.titleLabel.textColor = [UIColor whiteColor];
        self.weekEndButton.titleLabel.textColor = [UIColor whiteColor];
        self.laterButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
        self.weekEndButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("TubeStatus Fetcher", NULL);
        dispatch_async(downloadQueue, ^{
            
            [tubeStatus FetchXMLData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tubeStatusTableView reloadData];
            });
        });
        dispatch_release(downloadQueue);
        
        [self.view bringSubviewToFront:self.mainView];
        
        
        
        [self colors];
        [self addRefreshHeaderView]; 
    }
    else{
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not Connected to Internet" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
        return;
    }
    
}

- (void) addRefreshHeaderView{
    
    if (_refreshHeaderView == nil) {
		
		self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tubeStatusTableView.bounds.size.height, self.view.frame.size.width, self.tubeStatusTableView.bounds.size.height)];
		self.refreshView.delegate = self;
     
        [self.tubeStatusTableView addSubview:self.refreshView];
        
        _refreshHeaderView = self.refreshView;
    }
    //  update the last update date
   
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
}

- (void) colors{
    
    [tubeColors addObject:[UIColor colorWithRed:137.0/255.0 green:78.0/255.0 blue:36.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:220.0/255.0 green:36.0/255.0 blue:31.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:41.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:215.0/255.0 green:153.0/255.0 blue:175.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:134.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:117.0/255.0 green:16.0/255.0 blue:86.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:25.0/255.0 blue:168.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:160.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:118.0/255.0 green:208.0/255.0 blue:189.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:232.0/255.0 green:106.0/255.0 blue:16.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:135.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:136.0/255.0 blue:135.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:25.0/255.0 blue:168.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];

    
}

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
    _reloading = YES;
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tubeStatusTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if(headerText==@"Today"){
	TFLTubeStatusModel *tubeStatus = [[TFLTubeStatusModel alloc]init];
    tubeStatus.delegate = self;
    tubeStatus.statusFor = @"Today";
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("TubeStatus Fetcher", NULL);
    dispatch_async(downloadQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tubeStatusTableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


- (void)viewDidUnload
{
    [self setTubeStatusTableView:nil];
    [self setMessagePopupView:nil];
    
    [self setMainView:nil];
    [self setTextView:nil];
    [self setLaterStatusView:nil];
    [self setLaterStatusTableView:nil];
    [self setWeekEndStatusView:nil];
    [self setWeekEndStatusTableView:nil];
  
    [self setNowButton:nil];
    [self setLaterButton:nil];
    [self setWeekEndButton:nil];
    [self setBackgroundView:nil];
    [self setDoneView:nil];
    [self setDoneButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == self.tubeStatusTableView) {
        if([tubeStatusCopy count]>0){
            
            return 13;
        }   
    }
    if(tableView == self.weekEndStatusTableView)
    {
        if([tubeStatusWeekEnd count]>0){
            
            return 11;
        }   
    }
    
    if(tableView ==self.laterStatusTableView){
        if([tubeStatusLater count]>0){
    
            return 13;
        }   

        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(headerText == @"Later Dates"){
        return selectedDateInString;
    }
    else{
    return headerText;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([headerText isEqualToString:@"Today"]){
        self.backgroundView.hidden = NO;
        self.textView.text = [[tubeStatusCopy objectAtIndex:2]objectAtIndex:indexPath.row];
        if([self.textView.text length]>0){
        [self.messagePopupView setHidden:NO];
            [self.view bringSubviewToFront:self.messagePopupView];
        }
    }
    else if([headerText isEqualToString:@"WeekEnd"]){
          
        self.backgroundView.hidden = NO;
        self.textView.text = [[tubeStatusWeekEnd objectAtIndex:2]objectAtIndex:indexPath.row];
        if([self.textView.text length]>0){
        [self.messagePopupView setHidden:NO];
        [self.view bringSubviewToFront:self.messagePopupView];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tubeStatusTableView) {
        TubeStatusCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tubeStatusCell"];
        if (cell == nil) {
            cell = [[TubeStatusCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tubeStatusCell"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        
        cell.tubeName.text = [[tubeStatusCopy objectAtIndex:0]objectAtIndex:indexPath.row];
        
        cell.tubeStatus.text = [[tubeStatusCopy objectAtIndex:1]objectAtIndex:indexPath.row];
        
        cell.statusImage.image = [UIImage imageNamed:[[[tubeStatusCopy objectAtIndex:1]objectAtIndex:indexPath.row] stringByAppendingFormat:@".png"]];
        
        
                CGRect positionFrame = CGRectMake(10,14,30,30);
                CircleView * circleView = [[CircleView alloc] init:[tubeColors objectAtIndex:indexPath.row]];
                [circleView setFrame:positionFrame];
                circleView.backgroundColor =[UIColor whiteColor];
                [cell.contentView addSubview:circleView];   
        
        return cell;
   
    }
    if (tableView == self.weekEndStatusTableView) {
        TubeStatusCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tubeStatusWeekendCell"];
        if (cell == nil) {
            cell = [[TubeStatusCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tubeStatusWeekendCell"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        
        cell.tubeName.text = [[tubeStatusWeekEnd objectAtIndex:0]objectAtIndex:indexPath.row];
        
        cell.tubeStatus.text = [[tubeStatusWeekEnd objectAtIndex:1]objectAtIndex:indexPath.row];
        
        cell.statusImage.image = [UIImage imageNamed:[cell.tubeStatus.text stringByAppendingFormat:@".png"]];
        
               CGRect positionFrame = CGRectMake(10,14,30,30);
              CircleView * circleView = [[CircleView alloc] init:[tubeColors objectAtIndex:indexPath.row]];
                [circleView setFrame:positionFrame];
                circleView.backgroundColor =[UIColor whiteColor];
                [cell.contentView addSubview:circleView];   
        
        return cell;
        
    }
    
    if(tableView ==self.laterStatusTableView){
        
        TubeStatusCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tubeStatusLaterCell"];
        if (cell == nil) {
            cell = [[TubeStatusCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tubeStatusLaterCell"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        cell.tubeName.text = [[tubeStatusLater objectAtIndex:0]objectAtIndex:indexPath.row];
        
        cell.tubeStatus.text = [[tubeStatusLater objectAtIndex:1]objectAtIndex:indexPath.row];
        
        cell.statusImage.image = [UIImage imageNamed:[cell.tubeStatus.text stringByAppendingFormat:@".png"]];
        
               CGRect positionFrame = CGRectMake(10,14,30,30);
                CircleView * circleView = [[CircleView alloc] init:[tubeColors objectAtIndex:indexPath.row]];
             //   [circleView initWithFrame:positionFrame];
                [circleView setFrame:positionFrame];
                circleView.backgroundColor =[UIColor whiteColor];
                [cell.contentView addSubview:circleView];   
        
        return cell;

    }
    return nil;

}



- (IBAction)datePickerButtonPressed:(id)sender {
   
    [self showDatePicker];
    self.doneView.hidden = NO;
    self.doneButton.hidden = NO;
    self.cancelButton.hidden = NO;
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dueDateChanged:picker];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    self.doneView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [picker removeFromSuperview];
    self.doneView.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

- (IBAction)nowButtonPressed:(id)sender {
    
    if( [CheckNetwork isConnectedToNetwork]){
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
     self.nowButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    self.laterButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
    self.weekEndButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
   [self.nowButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
    self.laterButton.titleLabel.textColor = [UIColor whiteColor];
    self.weekEndButton.titleLabel.textColor = [UIColor whiteColor];
    
    
    [self.view bringSubviewToFront:self.mainView];
    TFLTubeStatusModel *tubeStatus = [[TFLTubeStatusModel alloc]init];
    tubeStatus.delegate = self;
    tubeStatus.statusFor = @"Today";
    headerText = @"Today";
    dispatch_queue_t downloadQueue = dispatch_queue_create("TubeStatus Fetcher", NULL);
    dispatch_async(downloadQueue, ^{
        
        [tubeStatus FetchXMLData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tubeStatusTableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
    
        [self.view bringSubviewToFront:self.mainView]; 
    }
    else{
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not Connected to Internet" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
        return;
    }

}
- (IBAction)laterButtonPressed:(id)sender {
    
     if( [CheckNetwork isConnectedToNetwork]){
    headerText = @"Later";
    self.laterButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    [self.laterButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
    self.nowButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
    self.weekEndButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];   
    self.nowButton.titleLabel.textColor = [UIColor whiteColor];
    self.weekEndButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.laterStatusView];
     }

    else{
        UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not Connected to Internet" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noInternetConnectionAlert show];
        return;
    }
}

- (IBAction)weekEndButtonPressed:(id)sender {
    
    if( [CheckNetwork isConnectedToNetwork]){
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    self.weekEndButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_pressed.png"]];
    self.nowButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
    self.laterButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_bg.png"]];
   [self.weekEndButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal] ;
    self.laterButton.titleLabel.textColor = [UIColor whiteColor];
    self.nowButton.titleLabel.textColor = [UIColor whiteColor];
    
    
    [self.view bringSubviewToFront:self.weekEndStatusView];
    
    TFLTubeStatusModel *tubeStatus = [[TFLTubeStatusModel alloc]init];
    tubeStatus.delegate = self;
    tubeStatus.statusFor = @"WeekEnd";
    headerText = @"WeekEnd";
    dispatch_queue_t downloadQueue = dispatch_queue_create("TubeStatus Fetcher", NULL);
    dispatch_async(downloadQueue, ^{
        
        [tubeStatus FetchXMLData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weekEndStatusTableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
    }
    
    else{
            UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not Connected to Internet" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [noInternetConnectionAlert show];
            return;
    }
        
}

#pragma mark Date Picker Fucnrtions

-(void)showDatePicker
{
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDate;
    //[picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    picker.frame = CGRectMake(0.0, 0.0, pickerSize.width, 460);
    picker.backgroundColor = [UIColor blackColor];
    [self.laterStatusView addSubview:picker];    
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    
    selectedDate = [sender date];
    [sender setHidden:YES];
   
    NSDateComponents *componentsForDate = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:selectedDate];
    
    NSInteger day = [componentsForDate day];
    NSInteger month = [componentsForDate month];
    NSInteger year = [componentsForDate year];
    selectedDateInString = [NSString stringWithFormat:@"%d/%d/%d",month,day,year];
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:[sender date] toDate:[NSDate date] options:0];
    NSInteger daysBetween = abs([components day]);
   
    diffInDate =[NSString stringWithFormat:@"%d", daysBetween];

    NSDate* timeNow = [NSDate date];
    
        
    if([diffInDate integerValue]<30 && [timeNow timeIntervalSinceDate:selectedDate] < (24*60*60.0f))
    {
       
        TFLTubeStatusModel *tubeStatus = [[TFLTubeStatusModel alloc]init];
        tubeStatus.statusFor = @"Later Dates";
        tubeStatus.diffInDate = diffInDate;
        tubeStatus.delegate = self;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("TubeStatus Fetcher", NULL);
        dispatch_async(downloadQueue, ^{
            
             [tubeStatus FetchXMLData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.laterStatusTableView reloadData];
            });
        });
        dispatch_release(downloadQueue);
    
        
    }
    else{
        UIAlertView *datesAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Dates within a Months time" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [datesAlert show];
    }
   
}

-(void) sendTubeWeekEndStatus:(NSMutableArray *)tubeStatusData{
   
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    tubeStatusWeekEnd = [tubeStatusData mutableCopy];
   
    headerText = @"WeekEnd";
   
}

-(void) sendTubeLaterStatus:(NSMutableArray *)tubeStatusData{
    
    headerText = @"Later Dates";
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    tubeStatusLater = [tubeStatusData mutableCopy];
   
}


- (IBAction)popupCloseButtonPressed:(id)sender {
    self.backgroundView.hidden = YES;
    [self.messagePopupView setHidden:YES];

}

@end
