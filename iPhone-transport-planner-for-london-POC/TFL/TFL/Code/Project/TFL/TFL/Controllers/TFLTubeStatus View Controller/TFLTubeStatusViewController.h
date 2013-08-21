//
//  TFLSecondViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TubeStatusCustomCell.h"

#import "EGORefreshTableHeaderView.h"
#import "CircleView.h"
#import "ProgressHUD.h"
#import "TFLTubeStatusModel.h"
#import "CheckNetwork.h"

//Tube Status of Today,LaterDates,and weekend 

@interface TFLTubeStatusViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,EGORefreshTableHeaderDelegate,TFLTubeStatusModel>
{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	BOOL _reloading;
}

@property (nonatomic,strong) EGORefreshTableHeaderView *refreshView;
@property (weak, nonatomic) IBOutlet UIView *doneView;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *messagePopupView;

@property (weak, nonatomic) IBOutlet UIView *laterStatusView;

@property (weak, nonatomic) IBOutlet UIView *weekEndStatusView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UITableView *tubeStatusTableView;

@property (weak, nonatomic) IBOutlet UITableView *laterStatusTableView;

@property (weak, nonatomic) IBOutlet UITableView *weekEndStatusTableView;

@property (nonatomic,strong) NSMutableArray *name;

@property (weak, nonatomic) IBOutlet UIButton *nowButton;

@property (weak, nonatomic) IBOutlet UIButton *laterButton;

@property (weak, nonatomic) IBOutlet UIButton *weekEndButton;

- (IBAction)popupCloseButtonPressed:(id)sender;

- (IBAction)nowButtonPressed:(id)sender;

- (IBAction)datePickerButtonPressed:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (void) colors;

- (void) showDatePicker;

- (void) addRefreshHeaderView;

- (void)reloadTableViewDataSource;

- (void)doneLoadingTableViewData;

-(void) dueDateChanged:(UIDatePicker *)sender;



@end
