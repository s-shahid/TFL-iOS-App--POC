//
//  pickAnOptionViewController.m
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pickAnOptionViewController.h"

@implementation pickAnOptionViewController

{
    NSMutableArray *tubeColors;
    NSIndexPath *lastIndexPath;
}
@synthesize optionTableView;
@synthesize navigationItem;
@synthesize options = _options;
@synthesize delegate = _delegate;
@synthesize tag = _tag;

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

- (void) colors{
    
    [tubeColors addObject:[UIColor colorWithRed:137.0/255.0 green:78.0/255.0 blue:36.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:220.0/255.0 green:36.0/255.0 blue:31.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:41.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:215.0/255.0 green:153.0/255.0 blue:175.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:134.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:117.0/255.0 green:16.0/255.0 blue:86.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:25.0/255.0 blue:168.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:0.0/255.0 green:160.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [tubeColors addObject:[UIColor colorWithRed:118.0/255.0 green:208.0/255.0 blue:189.0/255.0 alpha:1.0]];
    
 }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    tubeColors = [[NSMutableArray alloc]init ];
    self.optionTableView.delegate = self;
    self.optionTableView.dataSource = self;
    
    if([self.tag isEqualToString:@"1"]){
        
       self.navigationItem.title=  NSLocalizedStringFromTable(@"Pick a Line", @"Localization", @"");
    }
    else{
     
    self.navigationItem.title=  NSLocalizedStringFromTable(@"Pick a Station", @"Localization", @"");
    }
    [self colors];
   
}

- (void)viewDidUnload
{
    [self setOptionTableView:nil];
    [self setNavigationItem:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.options count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    cell.accessoryView = [[ UIImageView alloc ] 
                            initWithImage:[UIImage imageNamed:@"radio_deactive.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    if([self.tag isEqualToString:@"1"]){
    
    CGRect positionFrame = CGRectMake(12,14,30,30);
    cell.imageView.image = [UIImage imageNamed:@"Solid_white.png"];
    CircleView * circleView = [[CircleView alloc] init:[tubeColors objectAtIndex:indexPath.row]];
    [circleView setFrame:positionFrame];
    circleView.backgroundColor =[UIColor whiteColor];
    [cell.contentView addSubview:circleView];
    }
    
    if([self.options objectAtIndex:indexPath.row])
    cell.textLabel.text =[self.options objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.optionTableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"cell_single_pressed.png"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.backgroundView = imageView; 
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_active.png"]];
    [self.delegate sendSelectedStation:indexPath.row withTag:self.tag];
    [self dismissModalViewControllerAnimated:YES];
    [self.options removeAllObjects];
    
}


@end
