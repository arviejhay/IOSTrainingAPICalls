//
//  Typing.h
//  APICallsTest
//
//  Created by OPS on 14/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../Channels/Models/DatabasePresentation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Typing : NSObject<DatabasePresentation>
+ (instancetype)initWithIsTyping:(BOOL) isTyping;
@property BOOL isTyping;

@end

NS_ASSUME_NONNULL_END
