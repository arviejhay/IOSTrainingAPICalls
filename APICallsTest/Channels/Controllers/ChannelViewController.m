//
//  ChannelViewController.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "ChannelViewController.h"

@interface ChannelViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *didTapAddChannel;

@property FIRFirestore *db;
@property FIRCollectionReference * channelRef;

@property NSMutableArray * channels;

@property BOOL isFullyInitialized;

@property (weak,nonatomic) UIAlertController *alertController;
@property (nonatomic) UIVisualEffectView *blurEffectView;

- (void)fadeInAnimation;
- (void)fadeOutAnimation;
- (void)didTapSave;
- (void)didTapAddChannel;
- (void)showAlertWith:(NSString *) message;
- (void)handleDocumentChange:(FIRDocumentChange *)change;

- (void)addChannelToTable:(Channel *)channel;
- (void)updateChannelToTable:(Channel *)channel;
- (void)removeChannelToTable:(Channel *)channel;

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFullyInitialized = false;
    
    _channelView = (ChannelView *)[[[NSBundle mainBundle] loadNibNamed:@"ChannelView" owner:self options:nil] objectAtIndex:0];
    
    [_channelView.channelsTableView registerNib:[UINib nibWithNibName:[[ChannelTableViewCell alloc]cellName] bundle:nil] forCellReuseIdentifier:[[ChannelTableViewCell alloc] reuseIdentifier]];
    
    _channelView.frame = self.view.frame;
    _channelView.channelsTableView.delegate = self;
    _channelView.channelsTableView.dataSource = self;
    
    [self.view addSubview:_channelView];
    _welcomeNavigationTitle.title = [NSString stringWithFormat:@"Welcome, %@",[[AppSettings shared] getUsername]];
    
    _db = [FIRFirestore firestore];
    _channelRef = [_db collectionWithPath:@"channel"];
    
    ChannelViewController *vc = self;
 
    _channels = [[NSMutableArray alloc] init];
    
    [_channelRef addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil)
        {
            [vc showAlertWith:error.localizedDescription];
            NSLog(@"ERROR: %@",error.localizedDescription);
            return;
        }
        
        for (FIRDocumentChange *change in [snapshot documentChanges])
        {
            [vc handleDocumentChange:change];
        }
    }];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.bounds;
    _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_blurEffectView setOpaque:true];
    [_blurEffectView setAlpha:0];
    [self.view addSubview:_blurEffectView];
    
    
    // Do any additional setup after loading the view.
}

- (void)addChannelToTable:(Channel *)channel {
    BOOL isExist = false;
    if ([_channels count] != 0)
    {
        for (int i = 0; i < [_channels count];i++)
        {
            Channel *currentChannel = _channels[i];
            if ([channel.name isEqualToString:currentChannel.name])
            {
                isExist = true;
            }
        }
    }
    if (isExist == true && _isFullyInitialized == true)
    {
        [self showAlertWith:@"Name Already Exist! Please try another name"];
    }
    else if (isExist == false){
        [_channels addObject:channel];
        NSInteger index = [_channels count] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *paths = [NSArray arrayWithObjects:indexPath, nil];
        [self.channelView.channelsTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)removeChannelToTable:(Channel *)channel {
    for (int i = 0; i < [_channels count];i++)
    {
        Channel *currentChannel = _channels[i];
        NSString *givenChannelName = channel.name;
        NSString *currentChannelName = currentChannel.name;
        if ([givenChannelName isEqualToString:currentChannelName])
        {
            [_channels removeObjectAtIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSArray *paths = [NSArray arrayWithObjects:indexPath, nil];
            [self.channelView.channelsTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)updateChannelToTable:(Channel *)channel {
    for (int i = 0; i++; [_channels count])
    {
        Channel *currentChannel = _channels[i];
        if ([channel.name isEqualToString:currentChannel.name])
        {
            [_channels removeObjectAtIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSArray *paths = [NSArray arrayWithObjects:indexPath, nil];
            [self.channelView.channelsTableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)handleDocumentChange:(FIRDocumentChange *)change {
    Channel *channel = [Channel initWithDocument:change.document];
    if (channel == nil)
    {
        return;
    }
    switch (change.type)
    {
        case FIRDocumentChangeTypeAdded:
            [self addChannelToTable:channel];
            break;
        case FIRDocumentChangeTypeModified:
            [self updateChannelToTable:channel];
            break;
        case FIRDocumentChangeTypeRemoved:
            [self removeChannelToTable:channel];
            break;
        default:
            break;
    }
}


- (void)fadeInAnimation {
    [UIVisualEffectView animateWithDuration:1.0 animations:^{
        [self.blurEffectView setAlpha:0];
        [self.blurEffectView setAlpha:0.5];
    }];
}

- (void)fadeOutAnimation {
    [UIVisualEffectView animateWithDuration:1.0 animations:^{
        [self.blurEffectView setAlpha:0.5];
        [self.blurEffectView setAlpha:0];
    }];
}

- (IBAction)logOutButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapAddChannel:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create Channel" message:@"Please input a channel name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self didTapSave];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {}];
    [alert addAction:saveAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Channel name here";
    }];
    [alert addAction:cancelAction];
    
    _alertController = alert;
    [self presentViewController:alert animated:true completion:nil];
}

- (void)didTapSave {
    UITextField *textField = _alertController.textFields[0];
    if (textField == nil) {
        return;
    }
    ChannelViewController *vc = self;
    NSString *channelName = textField.text;
    Channel *channel = [Channel initWithName:channelName];
    [_channelView.channelAddLoader startAnimating];
    [self fadeInAnimation];
    [_channelRef addDocumentWithData:[channel representation] completion:^(NSError * _Nullable error) {
        [vc fadeOutAnimation];
        [vc.channelView.channelAddLoader stopAnimating];
        if (error == nil) {
            [vc showAlertWith:@"Adding Channel Successful!"];
        }
        else {
            [vc showAlertWith:error.localizedDescription];
        }
    }];
}

- (void)showAlertWith:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
    Channel *channel = _channels[indexPath.row];
    cell.ChannelCellTitle.text = channel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Channel *channel = _channels[indexPath.row];
    if (channel == nil)
    {
        return;
    }
    [self performSegueWithIdentifier:@"ChatSegue" sender:channel];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChatSegue"])
    {
        MessageChatViewController *mcvc = [segue destinationViewController];
        mcvc.channel = (Channel *)sender;
        mcvc.user = _currentUser;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Channel *channel = _channels[indexPath.row];
        [[_channelRef documentWithPath:channel.channelID] deleteDocument];
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
