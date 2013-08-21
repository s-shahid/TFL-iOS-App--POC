//
//  TFLDepartureDetailModel.m
//  TFL
//
//  Created by Mohammed Shahid on 08/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLDepartureDetailModel.h"

@implementation TFLDepartureDetailModel
{
    BOOL checkPlatform;
    NSMutableArray *platformNames;
    NSMutableDictionary *departureDict;
    NSMutableArray *departureArray;
    NSMutableArray *masterArray;
}
@synthesize searchDepartures = _searchDepartures;
@synthesize delegate = _delegate;

- (void) FetchXMLData{
    
    departureArray = [[NSMutableArray alloc]init];
    masterArray = [[NSMutableArray alloc]init];
    platformNames = [[NSMutableArray alloc]init];
    
    NSString *urlstring = [NSString stringWithFormat:@"http://cloud.tfl.gov.uk/TrackerNet/PredictionDetailed/%@",self.searchDepartures];
    
    NSURL *url = [[NSURL alloc] initWithString:urlstring];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    xmlParser.delegate = self;
    
    BOOL successInParsingTheXMLDocument = [xmlParser parse];
    
    if(successInParsingTheXMLDocument)
    {
        NSLog(@"No Errors In Parsing ");
    }
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    departureDict = [[NSMutableDictionary alloc]init];
    
    
    if([elementName isEqualToString:@"P"]){
        checkPlatform =YES;
    }
    
    if([attributeDict objectForKey:@"N"]&& checkPlatform )
        
    {  
        [platformNames addObject:[attributeDict objectForKey:@"N"]];
    }
    
    
    if([attributeDict objectForKey:@"TimeTo"]){
        
        [departureDict setObject:[attributeDict objectForKey:@"TimeTo"] forKey:@"timeTo"];
    }
    if([attributeDict objectForKey:@"Location"]){
        
        [departureDict setObject:[attributeDict objectForKey:@"Location"] forKey:@"at"];
    }
    if([attributeDict objectForKey:@"Destination"]){
        
        [departureDict setObject: [attributeDict objectForKey:@"Destination"] forKey:@"destination"];
    }
    
    if(checkPlatform)
        [departureArray addObject:departureDict];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"P"]){
        
        checkPlatform = NO;
        [masterArray addObject:departureArray];
        departureArray = [[NSMutableArray alloc]init];
        
        
    }
    if([elementName isEqualToString:@"S"]){
        
        [self.delegate sendDepartureInfo:masterArray andPlatform:platformNames];
        return ; 
    }
}


@end
