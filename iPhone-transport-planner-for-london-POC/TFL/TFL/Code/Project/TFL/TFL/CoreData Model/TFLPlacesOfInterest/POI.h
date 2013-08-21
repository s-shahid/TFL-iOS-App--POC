//
//  POI.h
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface POI : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;

@end
