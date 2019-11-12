//
//  AppSettings.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSettings : NSObject

+ (instancetype)shared;
- (void)setUsername:(NSString *)name;
- (NSString *)getUsername;

@end

NS_ASSUME_NONNULL_END
