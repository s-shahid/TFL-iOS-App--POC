//
//  TFLDisplayPreferencesOptionsViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFLDisplayPreferencesOptionsViewController;

@protocol TFLDisplayPreferencesOptionsViewControllerDelegate <NSObject>

- (void) sendSelectedInfo :(NSMutableArray *)preferencesInfo;

-(void) sendSelectedStepFreeAccessPreferences:(NSInteger)stepFreePreferences;

-(void) sendSelectedSpeedPreferences:(NSInteger)speedPreferences;

@end


@interface TFLDisplayPreferencesOptionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *selectionStatus;
    NSInteger selectedRow;
    
}
@property (nonatomic,strong) NSArray *preferencesOptions;

@property (nonatomic,strong) NSArray *selectedPreferences;

@property (weak, nonatomic) IBOutlet UITableView *preferencesOptionsTableView;

@property (strong ,nonatomic) id <TFLDisplayPreferencesOptionsViewControllerDelegate>delegate;

@property (nonatomic) BOOL isSingleSelection;

@property (nonatomic) BOOL isWalkingSpeed;

- (IBAction)doneButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end
