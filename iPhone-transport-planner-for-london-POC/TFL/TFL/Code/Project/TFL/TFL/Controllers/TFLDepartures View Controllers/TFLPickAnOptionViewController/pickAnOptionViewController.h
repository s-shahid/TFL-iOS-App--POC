//
//  pickAnOptionViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"


//delegate the selected option

@class pickAnOptionViewController;

@protocol pickAnOptionViewControllerDelegate <NSObject>

- (void) sendSelectedStation:(NSInteger )index withTag:(NSString *)tag;

@end


//Shows the list of Stations for user

@interface pickAnOptionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *optionTableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic,strong) NSMutableArray *options;

@property (nonatomic,strong) NSString *tag;

@property (strong ,nonatomic) id <pickAnOptionViewControllerDelegate>delegate;

@end
