//
//  DepartureCustomCell.h
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Departures Custom Cell for DepartureDetailViewController

@interface DepartureCustomCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *toStation;

@property (weak,nonatomic) IBOutlet UILabel *atStation;

@property (weak,nonatomic) IBOutlet UILabel *timeToArrive;

@end
