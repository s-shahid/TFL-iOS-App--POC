//
//  DepartureViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pickAnOptionViewController.h"
#import "stationCodesFetcher.h"
#import "DLRDetailViewController.h"
#import "CheckNetwork.h"

//Departures of Tubes And DLR

@interface DepartureViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,pickAnOptionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *departureTableView;

@property (weak, nonatomic) IBOutlet UIImageView *departureImageView;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIButton *findButton;

@property (weak, nonatomic) IBOutlet UIButton *tubeButton;

@property (weak, nonatomic) IBOutlet UIButton *DLRButton;

- (IBAction)tubeButtonPressed:(id)sender;

- (IBAction)DLRButtonPressed:(id)sender;

- (void) fetchRecords;

- (void) fetchUniqueRecords;

- (void) fetchStationsForTubeLine;

@end
