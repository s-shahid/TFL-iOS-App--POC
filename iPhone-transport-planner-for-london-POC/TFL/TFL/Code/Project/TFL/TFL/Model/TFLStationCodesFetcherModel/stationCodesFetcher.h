//
//  stationCodesFetcher.h
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stations.h"

//Station Codes Parsed From Text File and Saved into CoreData

@interface stationCodesFetcher : NSObject

@property (nonatomic,strong) NSMutableArray *stations;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

- (void) Parser;

@end
