//
//  Channel.m
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "Channel.h"

@implementation Channel

+ (instancetype)initWithName:(NSString *)name{
    Channel *channel = [[Channel alloc] init];
    channel.name = name;
    return channel;
}

+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document {
    NSDictionary *data = document.data;
    NSString* name = data[@"name"];
    if (name == nil)
    {
        return nil;
    }
    Channel * channel = [Channel initWithName:name];
    channel.channelID = [document documentID];
    return channel;
}
- (NSDictionary *)representation {
    NSDictionary *returnValue;
    returnValue = @{ @"name":_name };
    return returnValue;
}

@end
