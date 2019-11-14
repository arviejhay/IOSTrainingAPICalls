//
//  LogInViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

- (void)showAlertWith:(NSString *)message;

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
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.loginView.userNameTextField.text stringByTrimmingCharactersInSet:charSet];
    
    if ([trimmedString length] == 0)
    {
        [self showAlertWith:@"Username must not be blank!"];
    }
    else {
        [[AppSettings shared] setUsername:self.loginView.userNameTextField.text];
        [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error != nil)
            {
                [self showAlertWith:@"Error Signing In. Please try again."];
                return;
            }
            [self performSegueWithIdentifier:@"ChannelSegue" sender:[authResult user]];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChannelSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ChannelViewController *cvc = navVC.viewControllers[0];
        FIRUser *user = sender;
        cvc.currentUser = user;
    }
}

- (void)showAlertWith:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
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
