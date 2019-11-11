//
//  RestaurantMapView.h
//  APICallsTest
//
//  Created by OPS on 11/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantMapView : UIView
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

NS_ASSUME_NONNULL_END
