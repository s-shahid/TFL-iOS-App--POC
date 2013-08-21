//
//  DLRDetailViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Shows DLR Departures in an increasing order of time

@interface DLRDetailViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *departureDLRDetail;

@property (nonatomic ,strong)NSString *stationName;

@property (nonatomic ,strong) NSString *station;

- (void) FetchXMLData;

@end
