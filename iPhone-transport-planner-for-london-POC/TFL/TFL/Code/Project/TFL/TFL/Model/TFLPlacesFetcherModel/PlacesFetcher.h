//
//  PlacesFetcher.h
//  TFL
//
//  Created by Mohammed Shahid on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//Parses the venues file and Saves into CoreData

@interface PlacesFetcher : NSObject

@property (strong ,nonatomic)  NSMutableArray *placesArray;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

- (void) Parser;

- (void) fetchRecords;

@end
