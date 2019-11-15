//
//  LogInView.h
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogInViewDelegate <NSObject>

@required
- (void)didTapLogin;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LogInView : UIView
@property (weak, nonatomic) IBOutlet UIButton *didTapLogin;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) id<LogInViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
