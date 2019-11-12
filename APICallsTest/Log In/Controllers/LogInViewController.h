//
//  LogInViewController.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseAuth/FirebaseAuth.h>

#import "../Views/LogInView.h"

#import "../../Channels/Controllers/ChannelViewController.h"

#import "../../Class Utilities/Classes/AppSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogInViewController : UIViewController<LogInViewDelegate>
@property(weak, nonatomic) LogInView *loginView;
@end

NS_ASSUME_NONNULL_END
