//
//  DepartureCustomCell.m
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DepartureCustomCell.h"

@implementation DepartureCustomCell

@synthesize toStation = _toStation;
@synthesize timeToArrive = _timeToArrive;
@synthesize atStation = _atStation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
