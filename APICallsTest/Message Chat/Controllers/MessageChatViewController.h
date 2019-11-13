//
//  MessageChatViewController.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>

#import "../../Channels/Models/Channel.h"
#import "../Views/MessageChatView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageChatViewController : JSQMessagesViewController<JSQMessagesInputToolbarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *channelName;
@property Channel *channel;
@property (weak, nonatomic) MessageChatView *chatView;
- (instancetype)initWithChannel:(Channel *)channel;
- (void)setup;
- (void)handleThreadListener:(FIRDocumentChange *)changes;
@end

NS_ASSUME_NONNULL_END
