//
//  PlacesFetcher.m
//  TFL
//
//  Created by Mohammed Shahid on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesFetcher.h"
#import "POI.h"

@implementation PlacesFetcher
@synthesize placesArray = _placesArray;
@synthesize managedObjectContext = _managedObjectContext;


-(void) Parser{
  
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSString* fileRoot = [[NSBundle mainBundle] 
                          pathForResource:@"venues" ofType:@"txt"];
    
    
    // read everything from text
    NSString* fileContents = 
    [NSString stringWithContentsOfFile:fileRoot 
                              encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = 
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    // then break down even further 
    NSInteger i = 0;
    
    NSLog(@"lines:%d",[allLinedStrings count]);
    while (i<([allLinedStrings count]-1)) {
        
        NSString* strsInOneLine = 
        [allLinedStrings objectAtIndex:i];
        
        // choose whatever input identity you have decided. in this case ;
        NSArray* singleStrs = 
        [strsInOneLine componentsSeparatedByCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@","]];
       
      
        POI *poi = (POI *) [NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:_managedObjectContext];
        
       
        [poi setTitle:[singleStrs objectAtIndex:5]];
        [poi setLatitude:[singleStrs objectAtIndex:2]];
        [poi setLongitude:[singleStrs objectAtIndex:3]];
        [poi setAddress:[singleStrs objectAtIndex:4]];
        [poi setPostalCode:[singleStrs objectAtIndex:1]];
        [poi setType:[singleStrs objectAtIndex:6]];
        NSError *error;
        [_managedObjectContext save:&error];
        
       
        i++;        
    }  
    
}
- (void)fetchRecords {
	
	self.placesArray = [[NSMutableArray alloc]init ];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"POI" inManagedObjectContext:_managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
        
		NSLog(@"Sorry No Data");
	}
    
    NSInteger i;
    NSMutableDictionary *places = [[NSMutableDictionary alloc]init];
    
    
    for(i=0;i<[mutableFetchResults count];i++){
        
        POI *poi = [mutableFetchResults objectAtIndex:i];
        
        [places setObject:poi.title forKey:@"name"];
        [places setObject:poi.latitude forKey:@"lat"];
        [places setObject:poi.longitude forKey:@"lng"];
        [places setObject:poi.address forKey:@"address"];
        [places setObject:poi.postalCode forKey:@"postalCode"];
        [places setObject:poi.type forKey:@"type"];
        
        
        [self.placesArray addObject:places];
        
        NSLog(@"i=%d ,  %@",i,[self.placesArray objectAtIndex:i] );
     
    }  
    
}
@end
