//
//  DepartureDetailViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartureCustomCell.h"
#import "ProgressHUD.h"
#import "TFLDepartureDetailModel.h"

//Shows Tube Departures in an increasing order of time

@interface DepartureDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TFLDepartureDetailDelegate>

@property (weak, nonatomic) IBOutlet UITableView *departureTableView;

@property (nonatomic,strong) NSString *statioName;

@property (nonatomic ,strong) NSString *searchDepartures;

@property (nonatomic ,strong)  NSMutableArray *data;

- (void) collapse:(UIButton *)button;

@end
