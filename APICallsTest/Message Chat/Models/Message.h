//
//  Message.h
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <JSQMessage.h>
#import <Foundation/Foundation.h>
#import "../../Channels/Models/DatabasePresentation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject <DatabasePresentation>

@property NSString *senderID;
@property NSString *senderDisplayName;
@property NSDate *senderDate;
@property NSString *senderText;

@end

NS_ASSUME_NONNULL_END
