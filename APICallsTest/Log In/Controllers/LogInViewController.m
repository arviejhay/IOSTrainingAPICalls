//
//  LogInViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property(nonatomic) UIVisualEffectView *blurEffectView;
@property(nonatomic) UIActivityIndicatorView *loginLoader;

- (void)showAlertWith:(NSString *)message;
- (BOOL)isStringEmptyOrWhitespaces:(NSString *)givenString;

- (void)fadeInAnimation;
- (void)fadeOutAnimation;

- (void)clearTextFields;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
    // Do any additional setup after loading the view.
}

- (void)initializeView {
    _loginView = (LogInView *)[[[NSBundle mainBundle] loadNibNamed:@"LogInView" owner:self options:nil] objectAtIndex:0];
    _loginView.delegate = self;
    _loginView.frame = self.view.bounds;
    _loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:_loginView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.bounds;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_blurEffectView setOpaque:true];
    [_blurEffectView setAlpha:0];
    
    [self.view addSubview:_blurEffectView];
    
    _loginLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loginLoader.hidesWhenStopped = true;
    _loginLoader.center = self.view.center;
    
    [self.view addSubview:_loginLoader];

}

- (void)didTapLogin {
    NSString *email = self.loginView.emailTextField.text;
    NSString *password = self.loginView.passwordTextField.text;
    
    if ([self isStringEmptyOrWhitespaces:email] || [self isStringEmptyOrWhitespaces:password])
    {
        [self showAlertWith:@"Username or Password must not be blank!"];
    }
    else {
        [[AppSettings shared] setUsername:email];
        [self fadeInAnimation];
        [_loginLoader startAnimating];
        [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            [self fadeOutAnimation];
            [self.loginLoader stopAnimating];
            if (error != nil)
            {
                [self showAlertWith:@"Error Signing In. Please try again."];
                return;
            }
            [self clearTextFields];
            [self performSegueWithIdentifier:@"ChannelSegue" sender:[authResult user]];
        }];
    }
}

- (BOOL)isStringEmptyOrWhitespaces:(NSString *)givenString {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [givenString stringByTrimmingCharactersInSet:charSet];
    
    return [trimmedString length] == 0;
}

- (void)showAlertWith:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)fadeInAnimation {
    [UIVisualEffectView animateWithDuration:1.0 animations:^{
        [self.blurEffectView setAlpha:0];
        [self.blurEffectView setAlpha:1];
    }];
}

- (void)fadeOutAnimation {
    [UIVisualEffectView animateWithDuration:1.0 animations:^{
        [self.blurEffectView setAlpha:1];
        [self.blurEffectView setAlpha:0];
    }];
}

- (void)clearTextFields {
    self.loginView.emailTextField.text = @"";
    self.loginView.passwordTextField.text = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChannelSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ChannelViewController *cvc = navVC.viewControllers[0];
        FIRUser *user = sender;
        cvc.currentUser = user;
    }
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
