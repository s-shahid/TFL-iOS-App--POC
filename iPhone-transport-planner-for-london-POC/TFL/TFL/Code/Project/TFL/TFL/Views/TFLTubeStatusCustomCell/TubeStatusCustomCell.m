//
//  TubeStatusCustomCell.m
//  TFL
//
//  Created by Mohammed Shahid on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TubeStatusCustomCell.h"

@implementation TubeStatusCustomCell
@synthesize tubeName = _tubeName;
@synthesize tubeStatus = _tubeStatus;
@synthesize circleImage = _circleImage;
@synthesize statusImage = _statusImage;


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
