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
@property FIRCollectionReference *threadRef;
@property NSMutableArray<Message *> *messages;

- (void)showAlertWith:(NSString *)message;
- (void)sendMessage:(Message *)message;

@end

@implementation MessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _channelName.title = _channel.name;
    _messages = [[NSMutableArray alloc] init];
    
    [self setupInterface];
    [self setupFirebase];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
}

- (instancetype)initWithChannel:(Channel *)channel {
    MessageChatViewController *instance = [[MessageChatViewController alloc] initWithNibName:nil bundle:nil];
    instance.channel = channel;
    return instance;
}

- (void)setupInterface {
    self.inputToolbar.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setupFirebase {
    _db = [FIRFirestore firestore];
    NSString *stringUrl = [NSString stringWithFormat:@"channel/%@/thread",_channel.channelID];
    _threadRef = [_db collectionWithPath:stringUrl];
    
    MessageChatViewController *mcvc = self;
    
    [_threadRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
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

- (void)handleThreadListener:(FIRDocumentChange *)change {
    Message *msg = [Message initWithDocument:change.document];
    if (msg == nil)
    {
        return;
    }
    switch (change.type)
    {
        case FIRDocumentChangeTypeAdded:
            [_messages addObject:msg];
            [self.collectionView reloadData];
            [self scrollToBottomAnimated:true];
            break;
        default:
            break;
    }
}

- (void)showAlertWith:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_messages count];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _messages[indexPath.row];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = _messages[indexPath.row];
    NSLog(@"%@", [NSString stringWithFormat:@"I'm tapped : %@",msg.text]);
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesAvatarImageFactory *factory = [[JSQMessagesAvatarImageFactory alloc] init];
    Message *msg = _messages[indexPath.row];
    NSString *initial = @"❔";
    if ([msg.senderDisplayName length] != 0)
    {
        initial = [[msg.senderDisplayName substringToIndex:1] capitalizedString];
    }
    return [factory avatarImageWithUserInitials:initial backgroundColor:UIColor.darkGrayColor textColor:UIColor.lightTextColor font:[UIFont systemFontOfSize:16.f]];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesBubbleImageFactory *factory = [[JSQMessagesBubbleImageFactory alloc] init];
    Message *msg = _messages[indexPath.row];
    if ([[self senderId] isEqualToString:msg.senderId])
    {
        return [factory outgoingMessagesBubbleImageWithColor:UIColor.orangeColor];
    }
    return [factory incomingMessagesBubbleImageWithColor:UIColor.darkGrayColor];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 15.0f;
}
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 15.0f;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = _messages[indexPath.row];
    return [[NSAttributedString alloc] initWithString:msg.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = _messages[indexPath.row];
    FIRTimestamp *timestamp = (FIRTimestamp *)msg.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[timestamp dateValue]];
    return [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dateString]];
}

- (NSString *)senderId {
    return _user.uid;
}

- (NSString *)senderDisplayName {
    return [[AppSettings shared] getUsername];
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    Message *msg = [Message messageWithSenderId:senderId displayName:senderDisplayName text:text];
    if ([self isStringEmptyOrWhitespaces:msg.text] == NO)
    {
        [self sendMessage:msg];
        self.inputToolbar.contentView.textView.text = @"";
    }
}

- (BOOL)isStringEmptyOrWhitespaces:(NSString *)givenString {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [givenString stringByTrimmingCharactersInSet:charSet];
    
    return [trimmedString length] == 0;
}

- (void)didPressAccessoryButton:(UIButton *)sender {

}

- (void)sendMessage:(Message *)message {
    MessageChatViewController *mcvc = self;
    [_threadRef addDocumentWithData:message.representation completion:^(NSError * _Nullable error) {
        if (error != nil)
        {
            [mcvc showAlertWith:@"Failed sending message"];
        }
    }];
}

- (BOOL)automaticallyScrollsToMostRecentMessage {
    return true;
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
