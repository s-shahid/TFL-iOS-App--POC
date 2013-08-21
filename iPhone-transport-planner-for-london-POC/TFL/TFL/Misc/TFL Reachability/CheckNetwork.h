//
//  CheckNetwork.h
//  MyMap
//
//  Created by Akshay N Hegde on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface CheckNetwork : NSObject


+ (BOOL) isConnectedToNetwork;

@end
