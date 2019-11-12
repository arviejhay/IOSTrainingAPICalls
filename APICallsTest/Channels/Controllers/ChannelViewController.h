//
//  ChannelViewController.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseAuth/FirebaseAuth.h>

#import "../Views/ChannelView.h"

#import "../../Class Utilities/Classes/AppSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *welcomeNavigationTitle;
@property(weak, nonatomic) ChannelView *channelView;
@end

NS_ASSUME_NONNULL_END
