//
//  TFLFirstViewController.h
//  TFL
//
//  Created by Mohammed Shahid on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "placesAnnotations.h"
#import "POI.h"
#import "CalloutMapAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import "TFLRoutesViewController.h"
#import "TFLSearchModel.h"
#import "CoreLocation/CoreLocation.h"
#import "TFLPreferencesViewController.h"
#import "TFLRoutesAnnotations.h"
#import "ProgressHUD.h"
#import "CheckNetwork.h"

//Planner Tab with a Map View And List View To choose ..
//Search Bar along with a seperate Table View for Search Results

@interface TFLPlannerViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,TFLSearchResultsDelegate,TFLPreferencesViewControllerDelegate,UISearchBarDelegate>{
    
    CalloutMapAnnotation *_calloutAnnotation;
	MKAnnotationView *_selectedAnnotationView;
    placesAnnotations *_routeAnnotations;
}
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

- (UIImage *)makeThumbnailOfSize:(CGSize)size withImage:(UIImage *)image;


@property (weak, nonatomic) IBOutlet UIButton *changeViewButton;

- (IBAction)handleLongPressGestureRecogniser:(UILongPressGestureRecognizer *)sender;

@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;

@property (nonatomic ,strong) CalloutMapAnnotation *longPressCalloutAnnotation;

@property (weak, nonatomic) IBOutlet UIImageView * bottom_lineImageView;

@property (strong ,nonatomic) id <MKAnnotation> selectedAnnotation;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) NSArray *annotations;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (weak, nonatomic) IBOutlet UIView *mapsView;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong ,nonatomic) NSMutableArray *annotation;

- (IBAction)searchButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;

@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;

- (IBAction)changeViewButtonPressed:(UIButton *)sender;

@property (nonatomic,strong) UIPickerView *picker;

@property (nonatomic,strong) UIPickerView *depArrPickerView;

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,strong) placesAnnotations *placesAnnotation;

@property (nonatomic,strong) placesAnnotations *routeAnnotations;



@property (weak, nonatomic) IBOutlet UIView *doneView;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (void) showDatePicker:(NSIndexPath*)indexpath;

- (void) fetchRecords;

- (void) directionFromButtonPressed:(MKMapView *)mapView;

- (void) directionToButtonPressed;

-(void) fromButtonTapped:(UITapGestureRecognizer *)tgr;

-(void) toButtonTapped:(UITapGestureRecognizer *)tgr;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event ;

@end
