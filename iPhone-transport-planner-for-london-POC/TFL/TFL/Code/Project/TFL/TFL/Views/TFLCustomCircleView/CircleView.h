//
//  CircleView.h
//  TFL
//
//  Created by Mohammed Shahid on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Creates a circle for Tube Lines With Colors Matching

@interface CircleView : UIView

@property (weak,nonatomic) UIColor *color;

- (id) init:(UIColor *)tubeColor;

@end
