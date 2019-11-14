//
//  APIRetrieval.h
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void  (^ _Nullable  success)(NSURLSessionTask *_Nonnull __strong,id _Nullable __strong);

typedef void  (^ _Nullable  failure)(NSURLSessionTask *_Nonnull __strong,NSError *_Nullable __strong);

@protocol APIRetrievalDelegate <NSObject>

@required
- (void)retrieveDataWithSuccess:(success)successBlock withFailure:(failure)failureBlock withParameters:(NSDictionary *_Nullable)dictionary;

@end

NS_ASSUME_NONNULL_BEGIN

@interface APIRetrieval : NSObject

@property(nonatomic,copy, nullable) success successBlock;
@property(nonatomic,copy, nullable) failure failureBlock;
@property(copy, readwrite) NSDictionary *dictionary;
@property(copy,readwrite) NSString* apiKey;
@property(copy,readwrite) NSString* apiLink;

@property AFHTTPSessionManager *sessionManager;

@property id<APIRetrievalDelegate> delegate;

- (instancetype)initWithAPILink:(NSString *)link andAPIKey:(NSString *)key;
- (void)initAFNetworkingObject;
@end

NS_ASSUME_NONNULL_END
