//
//  ChannelViewController.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

#import "../Views/ChannelView.h"

#import "../../Class Utilities/Classes/AppSettings.h"
#import "../Views/Cell/ChannelTableViewCell.h"
#import "../Models/Channel.h"
#import "../../Message Chat/Controllers/MessageChatViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *welcomeNavigationTitle;
@property(weak, nonatomic) ChannelView *channelView;
@end

NS_ASSUME_NONNULL_END
