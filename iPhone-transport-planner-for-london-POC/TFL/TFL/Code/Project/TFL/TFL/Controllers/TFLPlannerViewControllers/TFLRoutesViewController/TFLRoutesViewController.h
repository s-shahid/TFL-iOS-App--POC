//
//  TFLRoutesViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 17/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutesDisplayCustomCell.h"
#import "TFLDetailRoutesViewController.h"
#import "ProgressHUD.h"




@interface TFLRoutesViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *routesTableView;

@property (nonatomic,strong) NSString *fromLocation;

@property (nonatomic,strong) NSString *fromLocationType;

@property (nonatomic,strong) NSString *toLocation;

@property (nonatomic,strong) NSString *toLocationType;

@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *typeArrDep;

@property (nonatomic,strong) NSString *travelPreferences;

- (void) checkForLocationType;

- (void) FetchXMLData;

@end
