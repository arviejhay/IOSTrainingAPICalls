//
//  RestaurantsMapViewController.m
//  APICallsTest
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "RestaurantsMapViewController.h"

@interface RestaurantsMapViewController ()

- (NSString *)createStarRatingStringWithSize:(int)ratingSize;
- (void)checkLocationAccess;

@end

@implementation RestaurantsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zoom = 15.0f;
    [self initializeView];
    [self startupMap];
    [self startLocationServices];
    // Do any additional setup after loading the view.
}

- (void)initializeView {
    _restaurantMap = (RestaurantMapView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantMapView" owner:self options:nil] objectAtIndex:0];
    _restaurantMap.frame = self.view.bounds;
    _restaurantMap.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_restaurantMap];
}

- (void)startupMap {
    for (id item in _listOfRestaurantsCoordinates)
    {
        NSDictionary *restaurantInfo = item;
        CLLocationCoordinate2D restaurantLocation;
        
        restaurantLocation.latitude = [restaurantInfo[@"lat"] floatValue];
        restaurantLocation.longitude = [restaurantInfo[@"long"] floatValue];
        
        GMSMarker *marker = [[GMSMarker alloc]init];
        
        marker.position = restaurantLocation;
        marker.title = restaurantInfo[@"name"];
        
        NSString *ratingUnround = restaurantInfo[@"ratings"];
        
        float ratingRound = roundf([ratingUnround floatValue]);
        
        if (ratingRound == 0)
        {
            marker.snippet = @"Ratings: \u2606 \u2606 \u2606 \u2606 \u2606";
        }
        else {
            marker.snippet = [self createStarRatingStringWithSize:(int)ratingRound];
        }
        marker.map = _restaurantMap.mapView;
    }
}

- (NSString *)createStarRatingStringWithSize:(int)ratingSize {
    NSMutableString *snippetMutable = [[NSMutableString alloc]initWithString:@"Ratings:"];
    
    for (int index = 0;index < ratingSize;index++)
    {
        [snippetMutable appendString:@" \u272D"];
    }
    
    int maximumRatingStarSize = 5;
    int remaningBlankStarSize = abs(((int)ratingSize - maximumRatingStarSize));
    
    for (int index = 0;index < remaningBlankStarSize;index++)
    {
        [snippetMutable appendString:@" \u2606"];
    }
    return [NSString stringWithString:snippetMutable];
}

- (void)startLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self checkLocationAccess];
        [_locationManager startUpdatingLocation];
    }
}

- (void)checkLocationAccess {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusDenied:
            [_locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestWhenInUseAuthorization];
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"There was an error retrieving your location/%@",error.localizedDescription];
    NSLog(@"Error: %@",msg);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *crnLoc = [locations lastObject];
    [self centerToLocation:crnLoc];
}

- (void)centerToLocation:(CLLocation *)location {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:_zoom];
    _restaurantMap.mapView.camera = camera;
    _restaurantMap.mapView.myLocationEnabled = true;
}

- (IBAction)goToBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
