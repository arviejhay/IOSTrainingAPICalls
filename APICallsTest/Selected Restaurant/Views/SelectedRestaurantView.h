//
//  SelectedRestaurantView.h
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedRestaurantView : UIView
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTimingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantRatingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCuisinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAverageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *restaurantInfoLoader;
@property (weak, nonatomic) IBOutlet UIView *selectedRestaurantInfoBottom;

@end

NS_ASSUME_NONNULL_END
