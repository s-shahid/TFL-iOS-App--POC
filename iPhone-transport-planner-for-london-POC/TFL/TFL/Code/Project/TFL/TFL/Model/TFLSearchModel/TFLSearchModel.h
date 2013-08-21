//
//  TFLSearchModel.h
//  TFL
//
//  Created by Mohammed Shahid on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Delagation Of Data to TFLPlannerView Controller

@class TFLSearchModel;

@protocol TFLSearchResultsDelegate <NSObject>

- (void) sendResponseForQuery:(NSArray *)data;

@end



@interface TFLSearchModel : NSObject

@property (strong,nonatomic) id <TFLSearchResultsDelegate> dataDelegate;

-(void) searchForPlaces:(NSString *)search;

@end
