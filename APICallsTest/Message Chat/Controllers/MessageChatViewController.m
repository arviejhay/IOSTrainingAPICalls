//
//  MessageChatViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "MessageChatViewController.h"

@interface MessageChatViewController ()
@property FIRFirestore *db;
@property FIRCollectionReference *channelRef;

- (void)showAlertWith:(NSString *)message;

@end

@implementation MessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _channelName.title = _channel.name;
    
    //_chatView = (MessageChatView *)[[[NSBundle mainBundle] loadNibNamed:@"MessageChatView" owner:self options:nil] objectAtIndex:0];
    
    //_chatView.frame = self.view.frame;
    
    //[self.view addSubview:_chatView];
    
    [self setup];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithChannel:(Channel *)channel {
    MessageChatViewController *instance = [[MessageChatViewController alloc] initWithNibName:nil bundle:nil];
    instance.channel = channel;
    return instance;
}

- (void)setup {
    _db = [FIRFirestore firestore];
    NSString *stringUrl = [NSString stringWithFormat:@"channel/%@/thread",_channel.name];
    _channelRef = [_db collectionWithPath:stringUrl];
    
    MessageChatViewController *mcvc = self;
    
    [_channelRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if (error != nil)
        {
            [mcvc showAlertWith:error.localizedDescription];
        }
        
        for (FIRDocumentChange *change in [snapshot documentChanges])
        {
            [mcvc handleThreadListener: change];
        }
    }];
}

- (void)handleThreadListener:(FIRDocumentChange *)changes {

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
