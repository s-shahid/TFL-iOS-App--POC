//
//  TFLTubeStatusModel.h
//  TFL
//
//  Created by Mohammed Shahid on 24/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>

@class TFLTubeStatusModel;

@protocol TFLTubeStatusModel <NSObject>

- (void) sendTubeStatus :(NSMutableArray *) tubeStatusData;
- (void) sendTubeWeekEndStatus :(NSMutableArray *) tubeStatusData;
- (void) sendTubeLaterStatus :(NSMutableArray *) tubeStatusData;
@end


@interface TFLTubeStatusModel : NSObject<NSXMLParserDelegate>
{
    
    NSString *headerText;
    NSInteger messageIndex;
    NSInteger messageIndexForWeekend;
    NSMutableArray *status;
    NSMutableArray *tubeColor;
    BOOL today;
    BOOL amp;
    
    
    NSMutableArray *tubeNames;
    NSMutableArray *tubeStatus;
    NSMutableArray *messageArray;
    NSMutableArray *weekendMessageArray;
    
    BOOL checkName;
    BOOL checkStatus;
    BOOL checkColor;
    BOOL checkMessage;
    BOOL messageText;
    BOOL statusText;
    NSString *lastString;
    
    NSMutableArray *tubeStatusData;
    
}

@property (weak,nonatomic) id <TFLTubeStatusModel> delegate;
@property (nonatomic,strong) NSString *statusFor;
@property (nonatomic,strong) NSString *diffInDate;
- (void) FetchXMLData;

@end
