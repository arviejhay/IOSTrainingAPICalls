//
//  HomeViewController.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

#import "../Views/HomeView.h"
#import "../Views/Cells/HomeTableViewCell.h"
#import "../Models/Category.h"

#import "../../All Restaurants/Controllers/RestaurantsViewController.h"
#import "../../Class Utilities/Delegates/APIRetrieval.h"
#import "../../Class Utilities/Delegates/Initializer.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,APIRetrievalDelegate,InitializerDelegate>

@property(strong, nonatomic) HomeView *homeView;
@property(weak, nonatomic) HomeViewController *hvc;
@property(copy, readwrite) NSMutableArray *categories;
@property(copy, readwrite) APIRetrieval *api;
@property(strong, nonatomic) CLLocationManager *locationManager;

@end

NS_ASSUME_NONNULL_END
