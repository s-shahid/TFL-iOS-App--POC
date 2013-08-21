//
//  RoutesDisplayCustomCell.h
//  TFL
//
//  Created by Mohammed Shahid on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Routes Available With All the below Entities

@interface RoutesDisplayCustomCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *route;

@property (weak,nonatomic) IBOutlet UILabel *travelTime;

@property (weak,nonatomic) IBOutlet UILabel *startTime;

@property (weak,nonatomic) IBOutlet UILabel *startMin;

@property (weak,nonatomic) IBOutlet UILabel *endTime;

@property (weak,nonatomic) IBOutlet UILabel *endMin;

@property (weak,nonatomic) IBOutlet UILabel *startAMPM;

@property (weak,nonatomic) IBOutlet UILabel *endAMPM;


@end
