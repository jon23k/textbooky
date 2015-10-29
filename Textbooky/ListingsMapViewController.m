//
//  ListingsMapViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/29/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "ListingsMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface ListingsMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) Annotation *annotationToAdd;

@end

@implementation ListingsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeLocationManager];
}

- (IBAction)pressedCheckIn:(id)sender {
    [self performSegueWithIdentifier:@"CheckInSegueIdentifier" sender:self];
}

- (IBAction)pressedFindMe:(id)sender {
    //    self.mapCenteredOnUser = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

//- (void)setAnnotationHolder:(Annotation *)annotatoin;
//{
//    self.annotationToAdd = annotatoin;
//}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    //initialize locationManager if necessary
//    [self initializeLocationManager];
    
    //Setup mapView, delegate, and default values
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //Start updating user location
    [self.locationManager startUpdatingLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    /*
    if ([[segue identifier] isEqualToString:@"CheckInSegueIdentifier"]){
        CheckInTableViewController *vc = [segue destinationViewController];
        [vc setValueForMapView:self.mapView];
    }
    */
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    //    CLLocation *location = [locations lastObject];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
{
    //    if (self.mapCenteredOnUser==YES){
    //        NSLog(@"Centering on user..");
    //        MKCoordinateRegion region;
    //        MKCoordinateSpan span;
    //        span.latitudeDelta = 0.01;
    //        span.longitudeDelta = 0.01;
    //        CLLocationCoordinate2D location;
    //        location.latitude = userLocation.coordinate.latitude;
    //        location.longitude = userLocation.coordinate.longitude;
    //        region.span = span;
    //        region.center = location;
    //        [self.mapView setRegion:region animated:YES];
    //    }
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated;
{
    //    if (mode == MKUserTrackingModeFollow) {
    ////        NSLog(@"Centering on user..");
    //        MKCoordinateRegion region;
    //        MKCoordinateSpan span;
    //        span.latitudeDelta = 0.01;
    //        span.longitudeDelta = 0.01;
    //        MKUserLocation *userLocation = [self.mapView userLocation];
    //        CLLocationCoordinate2D location;
    //        location.latitude = userLocation.coordinate.latitude;
    //        location.longitude = userLocation.coordinate.longitude;
    //        region.span = span;
    //        region.center = location;
    //        [self.mapView setRegion:region animated:YES];
    //    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *reuseIdentifier = @"annotationView";
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (annotationView==nil){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
    NSAssert([annotationView isKindOfClass:[MKPinAnnotationView class]], ([NSString stringWithFormat:@"%%", [annotationView class]]));
    MKPinAnnotationView *pin = (MKPinAnnotationView *)annotationView;
    
    pin.canShowCallout = YES;
    pin.pinTintColor = [MKPinAnnotationView redPinColor];
    pin.animatesDrop = YES;
    return pin;
}

#pragma mark - Private

- (void)initializeLocationManager;
{
    NSLog(@"Initializing Location Manager Object!");
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location Services Disabled :(");
        return;
    }
    
    if(self.locationManager==nil){
        self.locationManager = [[CLLocationManager alloc] init];
        NSLog(@"Initializing Location Services!");
    }
    
    self.locationManager.delegate = self;
    
    switch ([CLLocationManager authorizationStatus])  {
        case kCLAuthorizationStatusDenied:
            NSLog(@"LS Authorization Denied");
        case kCLAuthorizationStatusRestricted:
            NSLog(@"LS Authorization Restricted");
            return;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"LS Authorization Always");
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"LS Authorization In Use");
            return;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Requesting LS Authorization");
            [self.locationManager requestWhenInUseAuthorization];
            return;
    }
}

@end
