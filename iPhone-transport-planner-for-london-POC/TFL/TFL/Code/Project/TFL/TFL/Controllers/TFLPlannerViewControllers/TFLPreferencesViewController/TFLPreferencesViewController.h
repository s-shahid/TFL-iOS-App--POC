//
//  TFLPreferencesViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 24/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFLDisplayPreferencesOptionsViewController.h"

@class TFLPreferencesViewController;

@protocol TFLPreferencesViewControllerDelegate <NSObject>

- (void) sendSelectedPreferences:(NSString *)preferences;

@end



@interface TFLPreferencesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TFLDisplayPreferencesOptionsViewControllerDelegate>
{
    BOOL addIncludeMeansTag;
    
    BOOL checkWalkingRoutes;
    
    NSArray *walkingSpeed;
    
    NSArray *travelPreferences;
    
    NSString *selectedSpeed;
    
    NSArray *stepFreeAccess;
    
    NSMutableArray *selectedTransportPreferences; 
    
    NSString *selectedStepFreePreferences;

}
@property (strong,nonatomic) id <TFLPreferencesViewControllerDelegate> preferencesDelegate;

@property (weak, nonatomic) IBOutlet UITableView *preferencesTableView;

- (IBAction)doneButtonPressed:(id)sender;

@end
