//
//  TFLTubeStatusModel.m
//  TFL
//
//  Created by Mohammed Shahid on 24/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFLTubeStatusModel.h"

#define TUBESTATUS_NOW @"http://cloud.tfl.gov.uk/TrackerNet/LineStatus"

#define TUBESTATUS_WEEKEND @"http://www.tfl.gov.uk/tfl/businessandpartners/syndication/feed.aspx?email=rajashekaran@sourcebits.com&feedId=7"

#define TUBESTATUS_LATER @"http://www.tfl.gov.uk/tfl/syndication/feeds/disruptions-track-offset-"

@implementation TFLTubeStatusModel
@synthesize statusFor =_statusFor;
@synthesize delegate = _delegate;
@synthesize diffInDate = _diffInDate;

- (void) FetchXMLData{
    
    headerText = _statusFor;       
    NSURL *url ;
       
    
    if([headerText isEqualToString:@"Later Dates"]){
        
        if([self.diffInDate isEqualToString:@"0"]){
            url =[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@later.xml",TUBESTATUS_LATER]];
        }
        else
            url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@.xml",TUBESTATUS_LATER,self.diffInDate]];
            NSLog(@"%@",url);
    }
    
    else if ([headerText isEqualToString:@"WeekEnd"]) {
        
        url  = [[NSURL alloc] initWithString:TUBESTATUS_WEEKEND];
    
    }
    else{
    
        url = [[NSURL alloc] initWithString:TUBESTATUS_NOW];
    
    }  
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        messageArray = [[NSMutableArray alloc]init];
        tubeNames = [[NSMutableArray alloc]init];
        tubeStatus = [[NSMutableArray alloc]init];
        weekendMessageArray = [[NSMutableArray alloc]init];
        tubeStatusData = [[NSMutableArray alloc]init];
        tubeColor = [[NSMutableArray alloc]init];
        xmlParser.delegate = self;
        
        BOOL successInParsingTheXMLDocument = [xmlParser parse];
        
        if(successInParsingTheXMLDocument)
        {
            NSLog(@"No Errors In Parsing ");
        }
        else
        {
			UIAlertView *noInternetConnectionAlert = [[UIAlertView alloc]initWithTitle:@"No Connection" message:@"Unable to retrieve data.An Internet Connection is required." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Learn More", nil];
			[noInternetConnectionAlert show];
        }
          
    
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if(headerText == @"Today"){
        if([elementName isEqualToString:@"Line"])
        {
            
            [tubeNames addObject:[attributeDict objectForKey:@"Name"]];
        }
        if([elementName isEqualToString:@"Status"])
        {   
            
            [tubeStatus addObject:[attributeDict objectForKey:@"Description"]];
        }
        
        if([elementName isEqualToString:@"LineStatus"])
        {
            [messageArray insertObject:[attributeDict objectForKey:@"StatusDetails"] atIndex:messageIndex];
            messageIndex++;
            
        }
        
        
        
        
    }
    
    else if([headerText isEqualToString:@"Later Dates"]){
        
        if([elementName isEqualToString:@"line"]){
            [tubeNames addObject:[attributeDict objectForKey:@"name"]];
            [tubeStatus addObject:[attributeDict objectForKey:@"status"]];
        }
    }
    
    
    else{ 
        
        if([elementName isEqualToString:@"BgColour"]){
            
           
            checkColor = YES;
        } 
        
        if ([elementName isEqual:@"Name"]) {
            checkName = YES; 
             
        }
        if ([elementName isEqual:@"Status"]) {
            checkStatus = YES;
            
            
        }
        
        
        if([elementName isEqualToString:@"Text"]&& !checkMessage){
            
            statusText =YES;
        } 
        if([elementName isEqualToString:@"Message"]&& checkStatus){
            checkMessage = YES;
        }
        if([elementName isEqualToString:@"Text"] && checkMessage){
            
            messageText = YES;
        }
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(![headerText isEqualToString:@"Later Dates"]){
        if (([string isEqualToString:@"&"]||amp) && (!messageText))  {
            lastString = [tubeNames lastObject];
            [tubeNames removeLastObject];
            [tubeNames addObject:[lastString stringByAppendingString:string]];
            amp = YES;
        }
        if (checkName && ![string isEqualToString:@"&"]) {
            [tubeNames addObject:string];
            if(amp){
                [tubeNames removeLastObject];
            }
            amp=NO;
        }
        
        if(messageText){
            
            [weekendMessageArray addObject:string];
            
        }
        if(statusText){
            
            [tubeStatus addObject:string];
            if([string isEqualToString:@"Good service"]){
                [weekendMessageArray addObject:@""];
            }
            
        }
        
        
    } 
    
        
        if(checkColor&&!checkStatus){
            
            [tubeColor addObject:string];
           
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(headerText == @"Later Dates"){
        if ([elementName isEqualToString:@"lines"]) {
            
            [tubeStatusData addObject:tubeNames];
            [tubeStatusData addObject:tubeStatus];
            [self.delegate sendTubeLaterStatus:[tubeStatusData mutableCopy]];
        }
    }
    
    if(headerText == @"Today"){
        
        if([elementName isEqualToString:@"ArrayOfLineStatus"]){
            
            [tubeStatusData addObject:tubeNames];
            [tubeStatusData addObject:tubeStatus];
            [tubeStatusData addObject:messageArray];
            [self.delegate sendTubeStatus:[tubeStatusData mutableCopy]];
            return ;
        }
    }
    else{
        
        if([elementName isEqualToString:@"BgColour"]){
            
            checkColor = NO;
        }
        
        if ([elementName isEqual:@"TubeToday"]) {
            [tubeStatus removeObjectAtIndex:0];
            
            return;
        }
        if ([elementName isEqual:@"Name"]) {
            checkName = NO;
            
        }
        if([elementName isEqualToString:@"Text"]){
            if(checkMessage)
                messageText = NO;
            else if(statusText)
                statusText = NO;
        }
        if ([elementName isEqual:@"Status"]) {
            checkStatus = NO;
        }
        if([elementName isEqualToString:@"Message"]){
            checkMessage = NO;
        }
        
        if([elementName isEqualToString:@"SyndicatedFeed"]){
            [tubeStatus removeObjectAtIndex:0];
            [tubeStatusData addObject:tubeNames];
            [tubeStatusData addObject:tubeStatus];
            [tubeStatusData addObject:weekendMessageArray];
             [tubeStatusData addObject:tubeColor];
            [self.delegate sendTubeWeekEndStatus:tubeStatusData];
            return ; 
        }
    }
    
}


@end
