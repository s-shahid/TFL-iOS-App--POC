//
//  placesAnnotations.h
//  MapKitExample
//
//  Created by Mohammed Shahid on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface placesAnnotations : NSObject<MKAnnotation>


+ (placesAnnotations *) annotationForPlace:(NSDictionary *) place;

@property (strong ,nonatomic) NSDictionary *place;

@end
