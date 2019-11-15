//
//  RestaurantsMapViewController.h
//  APICallsTest
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "../Views/RestaurantMapView.h"

#import "../../Class Utilities/Delegates/Initializer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsMapViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate,InitializerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) RestaurantMapView *restaurantMap;
@property (copy, readwrite) NSMutableArray *listOfRestaurantsCoordinates;
@property (assign) float zoom;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)startupMap;
- (void)startLocationServices;
- (void)centerToLocation:(CLLocation *) location;
@end

NS_ASSUME_NONNULL_END
