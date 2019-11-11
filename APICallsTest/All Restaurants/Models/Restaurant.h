//
//  Restaurant.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSObject

@property(copy,readwrite) NSURL *imageURL;
@property(copy, readwrite) NSString *restaurantName;
@property(copy,readwrite) NSString *restaurantTiming;
@property(copy, readwrite) NSString *restaurantID;

- (instancetype)initWithImageURL:(NSURL *)url restaurantName:(NSString *)name restaurantTimings:(NSString *)timing restaurantID:(NSString *)ID;
@end

NS_ASSUME_NONNULL_END
