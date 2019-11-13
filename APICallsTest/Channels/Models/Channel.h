//
//  Channel.h
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "DatabasePresentation.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Channel : NSObject<DatabasePresentation>

@property(copy,readwrite) NSString *name;
@property(copy,readwrite) NSString *channelID;
+ (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
