//
//  TFLAppDelegate.h
//  TFL
//
//  Created by Mohammed Shahid on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"

@interface TFLAppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;




@property (strong, nonatomic) UIWindow *window;


- (NSString *)applicationDocumentsDirectory ;

@end
