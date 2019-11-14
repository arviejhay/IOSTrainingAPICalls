//
//  Initializer.h
//  APICallsTest
//
//  Created by OPS on 14/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InitializerDelegate <NSObject>

@required
- (void)initializeView;

@optional
- (void)initializeAPIResources;
- (void)initializeAPIResourcesWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude;

@end

@interface Initializer : NSObject

@property id<InitializerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
