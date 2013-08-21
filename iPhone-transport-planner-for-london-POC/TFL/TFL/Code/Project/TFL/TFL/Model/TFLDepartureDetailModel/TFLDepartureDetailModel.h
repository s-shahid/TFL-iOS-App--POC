//
//  TFLDepartureDetailModel.h
//  TFL
//
//  Created by Mohammed Shahid on 08/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFLDepartureDetailModel;

@protocol TFLDepartureDetailDelegate <NSObject>

- (void) sendDepartureInfo:(NSMutableArray *)departureInfo andPlatform:(NSMutableArray *)platformInfo;

@end


@interface TFLDepartureDetailModel : NSObject<NSXMLParserDelegate>

@property (nonatomic ,strong) NSString *searchDepartures;

@property (strong ,nonatomic) id <TFLDepartureDetailDelegate>delegate;

- (void) FetchXMLData;

@end
