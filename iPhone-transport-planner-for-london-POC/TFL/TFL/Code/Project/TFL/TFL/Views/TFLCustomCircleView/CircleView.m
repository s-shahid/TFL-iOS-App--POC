//
//  CircleView.m
//  TFL
//
//  Created by Mohammed Shahid on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView
@synthesize color = _color;

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    [self.color setFill];
    CGContextFillEllipseInRect(gc, CGRectMake(0,0,24,24));
    
    }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (id) init:(UIColor *)tubeColor{
    
    self = [super init];
    if(self){
        
        self.color = tubeColor;
    }
    return self;
    
}
@end
