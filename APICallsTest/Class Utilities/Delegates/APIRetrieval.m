//
//  APIRetrieval.m
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "APIRetrieval.h"

@interface APIRetrieval()

@end

@implementation APIRetrieval

- (instancetype)initWithAPILink:(NSString *)link andAPIKey:(NSString *)key {
    if (self)
    {
        self.apiKey = key;
        self.apiLink = link;
    }
    return self;
}

- (void)initAFNetworkingObject {
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.sessionManager.requestSerializer setValue:self.apiKey forHTTPHeaderField:@"user-key"];
}

@end
