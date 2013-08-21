//
//  TFLDisplayPreferencesOptionsViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLDisplayPreferencesOptionsViewController.h"

@implementation TFLDisplayPreferencesOptionsViewController



@synthesize navigationItem;
@synthesize preferencesOptions = _preferencesOptions;
@synthesize preferencesOptionsTableView;
@synthesize delegate = _delegate;
@synthesize isSingleSelection = _isSingleSelection;
@synthesize selectedPreferences = _selectedPreferences;
@synthesize isWalkingSpeed = _isWalkingSpeed;

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
    self.preferencesOptionsTableView.delegate = self;
    self.preferencesOptionsTableView.dataSource = self;
    if (!self.isSingleSelection) {
        self.preferencesOptionsTableView.allowsMultipleSelection = YES;
        self.navigationItem.title = @"Transport Preferences";
    }
    else{
        self.preferencesOptionsTableView.allowsSelection = YES;
        if (self.isWalkingSpeed) {
            self.navigationItem.title = @"Walking Speed";
        }
        else{
            self.navigationItem.title = @"Step Free Preferences";
        }
    }
    
    
     selectionStatus = [[NSMutableArray alloc]init];
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![standardUserDefaults objectForKey:@"TransportPreferences"]) {
        
       
        
        for (int count=0; count<11; count++) {
            
            [selectionStatus addObject:[NSString stringWithFormat:@"0"]];  
        }
        
        [standardUserDefaults setObject:selectionStatus forKey:@"TransportPreferences"];
    }
    else{
        
        selectionStatus = [[standardUserDefaults objectForKey:@"TransportPreferences"] mutableCopy];
    }
    
    
    if (self.isWalkingSpeed) {
        
        if ([standardUserDefaults integerForKey:@"SelectedSpeedPreferences"]) {
            
            selectedRow = [standardUserDefaults integerForKey:@"SelectedSpeedPreferences"];
            
            
        }
    }
    
    
    else {
     
        if([standardUserDefaults integerForKey:@"StepFreePreferences"]) {
            
            selectedRow = [standardUserDefaults integerForKey:@"StepFreePreferences"];

        } 
    }
    
  
}

- (void)viewDidUnload
{
  
    [self setPreferencesOptionsTableView:nil];
    [self setNavigationItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TableView Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreferencesOptionsCell"];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PreferencesOptionsCell"];
    }
    cell.textLabel.text = [self.preferencesOptions objectAtIndex:indexPath.row];
   
     
    if ([[selectionStatus objectAtIndex:indexPath.row]isEqualToString:@"1"]&&!self.isSingleSelection) {
    
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
   
    else if(selectedRow==indexPath.row&& self.isSingleSelection){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.preferencesOptionsTableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
       [selectionStatus replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"0"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (!self.isSingleSelection) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [selectionStatus replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else
    {
         selectedRow = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [self.preferencesOptionsTableView reloadData];
    
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.preferencesOptionsTableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (!self.isSingleSelection) {
        [selectionStatus replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"0"]];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.preferencesOptions count];
}



- (IBAction)doneButtonPressed:(id)sender {
    
        
    if (!self.isSingleSelection) {
        
        [self.delegate sendSelectedInfo:selectionStatus];  
        [[NSUserDefaults standardUserDefaults] setObject:selectionStatus forKey:@"TransportPreferences"];
        
    }
    else if(self.isWalkingSpeed){
    
            [self.delegate sendSelectedSpeedPreferences:selectedRow];
            [[NSUserDefaults standardUserDefaults] setInteger:selectedRow forKey:@"SelectedSpeedPreferences"];
    }
    else{
    
        [self.delegate sendSelectedStepFreeAccessPreferences:selectedRow];  
        [[NSUserDefaults standardUserDefaults] setInteger:selectedRow forKey:@"StepFreePreferences"];
        
         
        
    }

    [self dismissModalViewControllerAnimated:YES];
    
}
@end
