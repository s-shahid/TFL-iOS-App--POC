//
//  RouteSummaryCustomCell.h
//  TFL
//
//  Created by Mohammed Shahid on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Detailed Routes of a particular selected Route

@interface RouteSummaryCustomCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *stepNo;

@property (weak,nonatomic) IBOutlet UILabel *time;

@property (weak,nonatomic) IBOutlet UIImageView *transportImage;

@property (weak,nonatomic) IBOutlet UILabel *stepsMessage;

@property (weak,nonatomic) IBOutlet UIImageView *cellBottomImageView;

@property (weak,nonatomic) IBOutlet UIImageView *cellStripImageView;

@end
