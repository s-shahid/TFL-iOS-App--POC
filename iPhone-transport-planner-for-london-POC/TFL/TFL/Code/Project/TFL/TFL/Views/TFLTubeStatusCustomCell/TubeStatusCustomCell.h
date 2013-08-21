//
//  TubeStatusCustomCell.h
//  TFL
//
//  Created by Mohammed Shahid on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TubeStatusCustomCell : UITableViewCell


@property (weak,nonatomic) IBOutlet UILabel *tubeName;
@property (weak,nonatomic) IBOutlet UILabel *tubeStatus;
@property (weak,nonatomic) IBOutlet UIImageView *circleImage;
@property (weak,nonatomic) IBOutlet UIImageView *statusImage;

@end
