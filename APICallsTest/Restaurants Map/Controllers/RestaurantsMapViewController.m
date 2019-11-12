//
//  RestaurantsMapViewController.m
//  APICallsTest
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "RestaurantsMapViewController.h"

@interface RestaurantsMapViewController ()

@end

@implementation RestaurantsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zoom = 15.0f;
    
    _restaurantMap = (RestaurantMapView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantMapView" owner:self options:nil] objectAtIndex:0];
    _restaurantMap.frame = self.view.frame;
    
    [self.view addSubview:_restaurantMap];
    
    NSLog(@"%@",_listOfRestaurantsCoordinates);
    
    [self startupMap];
    [self startLocationServices];
    // Do any additional setup after loading the view.
}

- (IBAction)goToBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)startupMap {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:14.2190864 longitude:121.0449656];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:_zoom];
    _restaurantMap.mapView.camera = camera;
    _restaurantMap.mapView.myLocationEnabled = true;
    [self centerToLocation:location];
    
    for (id item in _listOfRestaurantsCoordinates)
    {
        NSDictionary *restaurantInfo = item;
        CLLocationCoordinate2D restaurantLocation;
        restaurantLocation.latitude = [restaurantInfo[@"lat"] floatValue];
        restaurantLocation.longitude = [restaurantInfo[@"long"] floatValue];
        
        GMSMarker *marker = [[GMSMarker alloc]init];
        marker.position = restaurantLocation;
        marker.title = restaurantInfo[@"name"];
        float ratingRound = roundf([restaurantInfo[@"ratings"] floatValue]);
        if (ratingRound == 0)
        {
            marker.snippet = @"Ratings: \u2606 \u2606 \u2606 \u2606 \u2606";
        }
        else {
            NSMutableString *snippetMutable = [[NSMutableString alloc]initWithString:@"Ratings:"];
            
            for (int i = 0;i < (int)ratingRound;i++)
            {
                [snippetMutable appendString:@" \u272D"];
            }
            for (int i = 0;i < abs(((int)ratingRound - 5));i++)
            {
                [snippetMutable appendString:@" \u2606"];
            }
            marker.snippet = [NSString stringWithString:snippetMutable];
        }
        marker.map = _restaurantMap.mapView;
    }
    
}

- (void)startLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
}

- (void)centerToLocation:(CLLocation *)location {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:_zoom];
    _restaurantMap.mapView.camera = camera;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"There was an error retrieving your location/%@",error.localizedDescription];
    NSLog(@"%@",msg);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //CLLocation *crnLoc = [locations lastObject];
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
