//
//  placesAnnotations.m
//  MapKitExample
//
//  Created by Mohammed Shahid on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "placesAnnotations.h"


@implementation placesAnnotations
@synthesize place = _place;

+ (placesAnnotations *) annotationForPlace:(NSDictionary *)place{
    
    placesAnnotations *placesAnnotation = [[placesAnnotations alloc ]init];  
    placesAnnotation.place = place;
    
    return placesAnnotation;
}

- (NSString *) title{
    
    return [self.place valueForKey:@"name"];
    
}
- (NSString *) subtitle{
    
    NSLog(@"%@",[self.place valueForKey:@"address"]);
    return [self.place valueForKey:@"address"];
    
}


- (CLLocationCoordinate2D)coordinate{
    
   
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [[self.place valueForKey:@"lat"]doubleValue];
    
    coordinate.longitude =[[self.place valueForKey:@"lng"]doubleValue];
   
    return coordinate;
    
}




@end
