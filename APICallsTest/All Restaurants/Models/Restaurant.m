//
//  Restaurant.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant
- (instancetype)initWithImageURL:(NSURL *)url restaurantName:(NSString *)name restaurantTimings:(NSString *)timing restaurantID:(NSString *)ID{
    if (self) {
        self.imageURL = url;
        self.restaurantName = name;
        self.restaurantTiming = timing;
        self.restaurantID = ID;
    }
    return self;
}
@end
