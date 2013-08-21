//
//  stationCodesFetcher.m
//  TFL
//
//  Created by Mohammed Shahid on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "stationCodesFetcher.h"

@implementation stationCodesFetcher
@synthesize managedObjectContext = _managedObjectContext;
@synthesize stations =  _stations;
-(void) Parser{
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSString* fileRoot = [[NSBundle mainBundle] 
                          pathForResource:@"Stations" ofType:@"txt"];
    
    
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
    while (i<([allLinedStrings count])) {
        
        NSString* strsInOneLine = 
        [allLinedStrings objectAtIndex:i];
        
        // choose whatever input identity you have decided. in this case ;
        NSArray* singleStrs = 
        [strsInOneLine componentsSeparatedByCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@","]];
        
      
       
        Stations *stations =(Stations *)  [NSEntityDescription insertNewObjectForEntityForName:@"Stations" inManagedObjectContext:_managedObjectContext];
        [stations setLineName:[singleStrs objectAtIndex:4]];
        [stations setLineCode:[singleStrs objectAtIndex:3]];
        [stations setStationCode:[singleStrs objectAtIndex:1]];
        [stations setStationName:[singleStrs objectAtIndex:2]];
       
         NSError *error;
        [_managedObjectContext save:&error];
        
       
        i++;        
    }  
    
}


@end
