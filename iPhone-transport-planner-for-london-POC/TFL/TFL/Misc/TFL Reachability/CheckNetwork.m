//
//  CheckNetwork.m
//  MyMap
//
//  Created by Akshay N Hegde on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckNetwork.h"

@implementation CheckNetwork


- (void) handleNoNetwork
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"Please ensure you are connected to the network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show]; 
}



+ (BOOL) isConnectedToNetwork
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
        return YES;
    }
    else {
        //there-is-no-connection warning
        return NO;
    }

}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"changed : yes");
    }
    else
    {
        NSLog(@"changed  :No");
        [self handleNoNetwork];
    }
}






@end
