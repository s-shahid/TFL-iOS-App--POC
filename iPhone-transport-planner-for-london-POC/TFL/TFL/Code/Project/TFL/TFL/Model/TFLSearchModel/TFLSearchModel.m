//
//  TFLSearchModel.m
//  TFL
//
//  Created by Mohammed Shahid on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLSearchModel.h"
#define SEARCH_URL @"http://192.168.16.36:3000/journey_planners/search_availability?origin="

@implementation TFLSearchModel
@synthesize dataDelegate = _dataDelegate;

-(void) searchForPlaces:(NSString *)search{
    
    NSString *request = [NSString stringWithFormat:@"%@%@",SEARCH_URL,search];
    
    request = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:request] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    [self.dataDelegate sendResponseForQuery:[[results objectForKey:@"response"]objectForKey:@"data"]];
}

@end
