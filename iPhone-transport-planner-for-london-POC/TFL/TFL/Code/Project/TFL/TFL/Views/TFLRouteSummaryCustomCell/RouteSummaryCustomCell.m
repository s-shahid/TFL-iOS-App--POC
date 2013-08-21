//
//  RouteSummaryCustomCell.m
//  TFL
//
//  Created by Mohammed Shahid on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteSummaryCustomCell.h"

@implementation RouteSummaryCustomCell

@synthesize stepNo = _stepNo;
@synthesize transportImage = _transportImage;
@synthesize time = _time;
@synthesize stepsMessage = _stepsMessage;
@synthesize cellBottomImageView = _cellBottomImageView;
@synthesize cellStripImageView = _cellStripImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
