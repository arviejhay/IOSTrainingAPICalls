//
//  AppSettings.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "AppSettings.h"

NSString * const userNameKey = @"username";

@implementation AppSettings

+ (instancetype)shared {
    static AppSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setUsername:(NSString *)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:userNameKey];
}

- (NSString *)getUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:userNameKey];
}

@end
