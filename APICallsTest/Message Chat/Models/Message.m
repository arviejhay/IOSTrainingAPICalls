//
//  Message.m
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "Message.h"

@implementation Message


+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document {
    NSDictionary *data = document.data;
    NSString *ID = data[@"senderId"];
    NSString *name = data[@"senderName"];
    NSDate *date = data[@"date"];
    NSString *text = data[@"text"];
    if (ID == nil)
    {
        return nil;
    }
    Message *message = [[Message alloc] initWithSenderId:ID senderDisplayName:name date:date text:text];
    return message;
}

- (NSDictionary *)representation {
    NSDictionary *data;
    data = @{ @"senderId": [self senderId],
              @"senderName": [self senderDisplayName],
              @"date": [self date],
              @"text": [self text]
              };
    return data;
}

@end
