//
//  ChannelViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "ChannelViewController.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _channelView = (ChannelView *)[[[NSBundle mainBundle] loadNibNamed:@"ChannelView" owner:self options:nil] objectAtIndex:0];
    
    
    [self.view addSubview:_channelView];
    
    _welcomeNavigationTitle.title = [NSString stringWithFormat:@"Welcome, %@",[[AppSettings shared] getUsername]];
    // Do any additional setup after loading the view.
}
- (IBAction)logOutButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
