//
//  SelectedRestaurant.m
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "SelectedRestaurant.h"

@implementation SelectedRestaurant
- (instancetype)initWithRestaurantInfoDictionary:(NSDictionary *)restaurantInfo {
    if (self)
    {
        self.imageURL = restaurantInfo[@"thumb"];
        self.restaurantName = restaurantInfo[@"name"];
        self.restaurantTiming = restaurantInfo[@"timings"];
        self.restaurantID = restaurantInfo[@"id"];
        self.restaurantAddress = restaurantInfo[@"address"];
        self.restaurantRatings = [restaurantInfo[@"ratings"] intValue];
        self.restaurantCuisines = restaurantInfo[@"cuisines"];
        self.restaurantAverageForTwo = [restaurantInfo[@"averageForTwo"] intValue];
    }
    return self;
}
@end
