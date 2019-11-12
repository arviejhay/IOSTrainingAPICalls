//
//  LogInViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginView = (LogInView *)[[[NSBundle mainBundle] loadNibNamed:@"LogInView" owner:self options:nil] objectAtIndex:0];
    _loginView.delegate = self;
    _loginView.frame = self.view.frame;
    
    
    [self.view addSubview:_loginView];
    // Do any additional setup after loading the view.
}

- (void)didTapLogin {
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        //FIRUser *user = authResult.user;
        [[AppSettings shared] setUsername:self.loginView.userNameTextField.text];
        //NSLog(@"%@",[[AppSettings shared] getUsername]);
        [self performSegueWithIdentifier:@"ChannelSegue" sender:self];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
