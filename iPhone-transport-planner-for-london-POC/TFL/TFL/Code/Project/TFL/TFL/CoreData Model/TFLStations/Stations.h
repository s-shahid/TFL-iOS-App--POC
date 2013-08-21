//
//  Stations.h
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stations : NSManagedObject

@property (nonatomic, retain) NSString * stationCode;
@property (nonatomic, retain) NSString * stationName;
@property (nonatomic, retain) NSString * lineCode;
@property (nonatomic, retain) NSString * lineName;

@end
