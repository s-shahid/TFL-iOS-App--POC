//
//  TFLPreferencesViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 24/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLPreferencesViewController.h"

#define Slow @"200"
#define Fast @"50"
#define Normal @"100"

#define UseNoElevators @"&imparedOptionsActive=1&noElevators=‐"
#define UseEscalotorsButNotStairs @"&imparedOptionsActive=1&noSolidStairs=‐"
#define UseStairsButNoEscalators @"&imparedOptionsActive=1&noEscalators=‐"
#define NoRequirements @"&stepfree-access=no-requirements"

@implementation TFLPreferencesViewController

@synthesize preferencesTableView = _preferencesTableView;
@synthesize preferencesDelegate = _preferencesDelegate;


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
    
   
    selectedTransportPreferences = [[NSMutableArray alloc]init]; 
    self.preferencesTableView.delegate =self;
    self.preferencesTableView.dataSource = self;
    
    walkingSpeed = [[NSArray alloc]initWithObjects:@"Slow",@"Normal",@"Fast",nil];
    
    travelPreferences = [[NSArray alloc]initWithObjects:@"Train",@"Commuter railway",@"City Rail",@"Tram",@"City Bus",@"Regional Bus",@"Coach",@"Boat",@"Transit on demand",nil];
    
    stepFreeAccess = [[NSArray alloc]initWithObjects:@"Use No Elevators",@"Use Escalotors But Not Stairs",@"Use Stairs But No Escalators",@"No Requirements" ,nil]; 
   
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
     if ([standardUserDefaults objectForKey:@"TransportPreferences"]) {
        
        selectedTransportPreferences =  [[standardUserDefaults objectForKey:@"TransportPreferences"] mutableCopy];
     }
        else{
        
            for (int count=0; count<8; count++) {
            
            [selectedTransportPreferences addObject:[NSString stringWithFormat:@"0"]];  
            } 
        }
    
     if ([standardUserDefaults integerForKey:@"StepFreePreferences"]) {
        
        selectedStepFreePreferences = [stepFreeAccess objectAtIndex:[standardUserDefaults integerForKey:@"StepFreePreferences"]];
     }
    
    if ([standardUserDefaults integerForKey:@"SelectedSpeedPreferences"]>=0) {
        
        selectedSpeed = [walkingSpeed objectAtIndex:[standardUserDefaults integerForKey:@"SelectedSpeedPreferences"]];
    }
    else{
        selectedSpeed = @"";
    }
    
    [self.preferencesTableView setBackgroundColor:[UIColor clearColor]]; 
}

- (void)viewDidUnload
{
    [self setPreferencesTableView:nil];
    [super viewDidUnload];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self doneButtonPressed:self];
        
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TableView Delegate Methods


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreferencesCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PreferencesCell"];
    }
    
    switch ([indexPath section]) {
        case 0:
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"Step Free Access";
                cell.detailTextLabel.text = selectedStepFreePreferences;
               
                
            }
            else if(indexPath.row == 1){
                cell.textLabel.text = @"Transport Modes";
                
                cell.detailTextLabel.text = @"";
                NSInteger count = [selectedTransportPreferences count];
                for (int i=0; i<count; i++) {
                    if ([[selectedTransportPreferences objectAtIndex:i]isEqualToString:@"1"]) {
                        
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",cell.detailTextLabel.text,[travelPreferences objectAtIndex:i]];
                    }
                    
                }
                
            }
            break;
        case 1:
        {
            
            cell.textLabel.text = @"Cycling Routes";
            
            cell.detailTextLabel.text = @"";
            
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            
            if ([standardUserDefaults boolForKey:@"CyclingRoutes"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
               
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }  
            break;
            
        case 2:
            
        {
            
            cell.textLabel.text = @"Walking Routes";
            cell.detailTextLabel.text = @"";
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            if ([standardUserDefaults objectForKey:@"SelectedSpeedPreferences"]) {
                checkWalkingRoutes = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }    
        case 3:
            
            cell.textLabel.text = @"Speed Of Walking";
            cell.detailTextLabel.text = selectedSpeed;
            
            break;
                    
        default:
            break;
    }
    
    return cell;
    
    
}

-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return 2;
    }
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if(checkWalkingRoutes||[standardUserDefaults objectForKey:@"SelectedSpeedPreferences"]){
         return 4;
    }
    else        
        return 3;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell *cell = [self.preferencesTableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    switch ([indexPath section]) {
        case 0:
            
            
            if(indexPath.row == 0){
                
                [self.preferencesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                [self performSegueWithIdentifier:@"StepFreeAccessSelection" sender:self];
                
            }
            
            
           else if(indexPath.row == 1){
                [self performSegueWithIdentifier:@"PreferencesSelection" sender:self];
            }
            
            break;
        case 1:
            
        {
            
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                [standardUserDefaults setBool:NO forKey:@"CyclingRoutes"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [standardUserDefaults setBool:YES forKey:@"CyclingRoutes"];
            }
            
        }    
            break;
            
        case 2:
            
            if(!checkWalkingRoutes){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                checkWalkingRoutes = YES;
               
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [standardUserDefaults setObject:nil forKey:@"SelectedSpeedPreferences"];
                checkWalkingRoutes = NO;
                
            }
            
            [self.preferencesTableView reloadData];
            
            break;
            
            
        case 3:
            
            [self.preferencesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [self performSegueWithIdentifier:@"WalkingSpeedPreferences" sender:self];
            
            break;
            
        default:
            break;
    }
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"PreferencesSelection"]){
        
        TFLDisplayPreferencesOptionsViewController *preferencesDisplay = [segue destinationViewController];
        preferencesDisplay.preferencesOptions = travelPreferences;
        preferencesDisplay.isSingleSelection = NO;
        preferencesDisplay.isWalkingSpeed = NO;
        preferencesDisplay.selectedPreferences = selectedTransportPreferences;
        preferencesDisplay.delegate = self;
    }
    
    else if([segue.identifier isEqualToString:@"StepFreeAccessSelection"]){
        
        TFLDisplayPreferencesOptionsViewController *stepFreePreferences = [segue destinationViewController];
        stepFreePreferences.preferencesOptions = stepFreeAccess;
        stepFreePreferences.isSingleSelection = YES;
        stepFreePreferences.isWalkingSpeed = NO;
        stepFreePreferences.delegate = self;
        
        
    }
    else if([segue.identifier isEqualToString:@"WalkingSpeedPreferences"]){
        
        TFLDisplayPreferencesOptionsViewController *walkingSpeedPreferences = [segue destinationViewController];
        walkingSpeedPreferences.preferencesOptions = walkingSpeed;
        walkingSpeedPreferences.isSingleSelection = YES;
        walkingSpeedPreferences.isWalkingSpeed =YES;
        walkingSpeedPreferences.delegate = self;
    }
    
}
- (IBAction)doneButtonPressed:(id)sender {
    
    NSString *preferencesURLAppend = @"";
    
    if (selectedSpeed == @"Normal") {
        
            preferencesURLAppend = [NSString stringWithFormat:@"%@&itOptionsActive=1&speed=%@",preferencesURLAppend,Normal];
    }
    else if(selectedSpeed == @"Slow"){
            preferencesURLAppend = [NSString stringWithFormat:@"%@&itOptionsActive=1&speed=%@",preferencesURLAppend,Slow];
    }
    else if(selectedSpeed == @"Fast"){
    
            preferencesURLAppend = [NSString stringWithFormat:@"%@&itOptionsActive=1&speed=%@",preferencesURLAppend,Fast];
    }
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([standardUserDefaults boolForKey:@"CyclingRoutes"] ) {
    
        preferencesURLAppend = [NSString stringWithFormat:@"%@&cycleType=107",preferencesURLAppend];
    }
    
    if ([standardUserDefaults integerForKey:@"StepFreePreferences"]) {
        
        if ([selectedStepFreePreferences isEqualToString:@"Use No Elevators"]) {
            preferencesURLAppend = [NSString stringWithFormat:@"%@%@",preferencesURLAppend,UseNoElevators];
        }
        else  if ([selectedStepFreePreferences isEqualToString:@"Use Escalotors But Not Stairs"]) {
            preferencesURLAppend = [NSString stringWithFormat:@"%@%@",preferencesURLAppend,UseEscalotorsButNotStairs];
        }
        else  if ([selectedStepFreePreferences isEqualToString:@"Use Stairs But No Escalators"]) {
            preferencesURLAppend = [NSString stringWithFormat:@"%@%@",preferencesURLAppend,UseStairsButNoEscalators];
        }
        else{
            preferencesURLAppend = [NSString stringWithFormat:@"%@%@",preferencesURLAppend,NoRequirements];
        }
    }
    
    
    for (NSInteger count=0;count < [selectedTransportPreferences count]; count++) {
        
        if ([[selectedTransportPreferences objectAtIndex:count]isEqualToString:@"1"]) {
            
            preferencesURLAppend = [NSString stringWithFormat:@"%@&inclMOT_%d=‐",preferencesURLAppend,count];
            if (!addIncludeMeansTag) {
                preferencesURLAppend = [NSString stringWithFormat:@"%@&includedMeans=1",preferencesURLAppend];
                addIncludeMeansTag = YES;
            }

        }        
    }

    
    [self.preferencesDelegate sendSelectedPreferences:preferencesURLAppend];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) sendSelectedInfo:(NSMutableArray *)preferencesInfo{
    
   
        selectedTransportPreferences =  preferencesInfo;

        [self.preferencesTableView reloadData];
}

-(void) sendSelectedStepFreeAccessPreferences:(NSInteger )stepFreePreferences{
    
    
    selectedStepFreePreferences =[stepFreeAccess objectAtIndex:stepFreePreferences];
    [self.preferencesTableView reloadData];
    
}
-(void) sendSelectedSpeedPreferences:(NSInteger )speedPreferences{
    
    selectedSpeed = [walkingSpeed objectAtIndex:speedPreferences];
    
    [self.preferencesTableView reloadData];
    
}
@end
