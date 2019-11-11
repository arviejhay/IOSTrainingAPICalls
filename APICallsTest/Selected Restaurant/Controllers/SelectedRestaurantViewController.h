//
//  SelectedRestaurantViewController.h
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>

#import "../Views/SelectedRestaurantView.h"
#import "../Models/SelectedRestaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedRestaurantViewController : UIViewController
@property(weak, nonatomic) SelectedRestaurantView *selectedRestaurantView;
@property(copy, readwrite) NSDictionary *selectedRestaurantInfo;
@property(readwrite) SelectedRestaurant *selectedRestaurant;
@property (weak, nonatomic) IBOutlet UINavigationItem *selectedNavigationTitle;
- (void)getRestaurantByID;
@end

NS_ASSUME_NONNULL_END
