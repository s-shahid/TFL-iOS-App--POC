//
//  TFLDetailRoutesViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSummaryCustomCell.h"
#import "MapKit/MapKit.h"
#import "placesAnnotations.h"


//Shows Detailed Partial Routes to Destination with Step by Step Navigation

@interface TFLDetailRoutesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    NSMutableArray *meansOfTransport;
     MKPolyline *polyLine ;
     MKCircle *circle;
    BOOL checkChangeViewButton;
}


@property (weak, nonatomic) IBOutlet UIView *navigationView;

@property (weak, nonatomic) IBOutlet UITableView *routeSummaryTableView;
- (IBAction)backNavigationButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *navigationTextView;
@property (weak, nonatomic) IBOutlet UIButton *changeViewButton;

@property (strong ,nonatomic) NSMutableArray *annotation;

@property (nonatomic,strong) NSString *routeNo;

- (IBAction)forwardNavigationButtonPressed:(id)sender;

@property (nonatomic,strong) NSMutableDictionary *route;

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (weak, nonatomic) IBOutlet UIView *mapView_uiView;

@property (weak, nonatomic) IBOutlet MKMapView *routesMapView;

@property (nonatomic,strong) placesAnnotations *placesAnnotation;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *navigationStepNo;




- (IBAction)changeViewButtonPressed:(id)sender;

-(void) drawPolyline:(NSMutableDictionary *)coordinateData ;

-(CGFloat)getLabelHeightForIndex:(NSInteger)index;

@end
