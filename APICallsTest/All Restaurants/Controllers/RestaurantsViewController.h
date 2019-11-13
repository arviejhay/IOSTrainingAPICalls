//
//  RestaurantsViewController.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import <CoreLocation/CoreLocation.h>

#import "../Views/RestaurantsView.h"
#import "../Models/Restaurant.h"
#import "../Views/Cells/RestaurantCollectionViewCell.h"
#import "../../Selected Restaurant/Controllers/SelectedRestaurantViewController.h"
#import "../../Restaurants Map/Controllers/RestaurantsMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *selectedCategoryTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *restaurantsMap;

@property(copy, readwrite) NSMutableArray *restaurants;
@property(copy, readwrite) NSMutableArray *locationsInfoRestaurants;

@property(strong, nonatomic) CLLocationManager* locationManager;

@property(copy, readwrite) NSString *selectedCategoryID;

@property(weak, nonatomic) RestaurantsView *restaurantView;

@property(copy, readwrite) NSString *latitude;
@property(copy, readwrite) NSString *longtitude;

- (void)getAllRestaurantsBasedCategoryWithLatitude:(NSString *)latitude andLongtitude:(NSString *)lon;
- (void)setHiddenForBarButton:(BOOL)enabled;
- (void)startLocationService;
@end

NS_ASSUME_NONNULL_END
