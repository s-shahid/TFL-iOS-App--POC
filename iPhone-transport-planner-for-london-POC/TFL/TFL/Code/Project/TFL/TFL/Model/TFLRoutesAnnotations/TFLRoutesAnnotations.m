//
//  TFLRoutesAnnotations.m
//  TFL
//
//  Created by Mohammed Shahid on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLRoutesAnnotations.h"

@implementation TFLRoutesAnnotations

@synthesize longitude = _longitude;
@synthesize latitude = _latitude;



- (id)initWithLatitude:(CLLocationDegrees)locationLatitude
		  andLongitude:(CLLocationDegrees)locationLongitude {
	if (self = [super init]) {
		self.latitude = locationLatitude;
		self.longitude = locationLongitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate{
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    
    coordinate.longitude =self.longitude;
    
    
    return coordinate;
    
}



@end
