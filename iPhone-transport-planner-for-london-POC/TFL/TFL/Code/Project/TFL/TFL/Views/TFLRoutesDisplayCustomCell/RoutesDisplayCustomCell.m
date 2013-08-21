//
//  RoutesDisplayCustomCell.m
//  TFL
//
//  Created by Mohammed Shahid on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoutesDisplayCustomCell.h"


@implementation RoutesDisplayCustomCell

@synthesize route = _route;

@synthesize travelTime = _travelTime;

@synthesize startTime =_startTime;

@synthesize startMin = _startMin;

@synthesize endTime = _endTime;

@synthesize endMin = _endMin;

@synthesize startAMPM = _startAMPM;

@synthesize endAMPM = _endAMPM;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void) prepareForReuse
{

        __strong UIView *view;
        for(view in self.contentView.subviews)
        {
            if(view.tag == 100)
            {
                [view removeFromSuperview];
            }
        }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
