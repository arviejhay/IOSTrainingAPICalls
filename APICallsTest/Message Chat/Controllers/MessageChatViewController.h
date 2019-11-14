//
//  MessageChatViewController.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseFirestore/FirebaseFirestore.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <JSQMessagesViewController/JSQMessagesBubbleImageFactory.h>
#import <JSQMessagesViewController/JSQMessagesAvatarImageFactory.h>

#import "../Models/Message.h"
#import "../Views/MessageChatView.h"

#import "../../Channels/Models/Channel.h"
#import "../../Class Utilities/Classes/AppSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageChatViewController : JSQMessagesViewController<JSQMessagesInputToolbarDelegate,JSQMessagesCollectionViewCellDelegate, JSQMessagesCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *channelName;
@property Channel *channel;
@property (weak, nonatomic) MessageChatView *chatView;
@property (weak, nonatomic) FIRUser *user;
- (void)setupFirebase;
- (void)setupInterface;
- (void)handleThreadListener:(FIRDocumentChange *)changes;
@end

NS_ASSUME_NONNULL_END
