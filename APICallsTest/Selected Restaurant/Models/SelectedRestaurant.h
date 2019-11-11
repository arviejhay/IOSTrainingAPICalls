//
//  SelectedRestaurant.h
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../All Restaurants/Models/Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedRestaurant : Restaurant
@property(copy,readwrite) NSString *restaurantAddress;
@property(assign) int restaurantRatings;
@property(copy,readwrite) NSString *restaurantCuisines;
@property(assign) int restaurantAverageForTwo;

- (instancetype)initWithRestaurantInfoDictionary:(NSDictionary *)restaurantInfo;
@end

NS_ASSUME_NONNULL_END
