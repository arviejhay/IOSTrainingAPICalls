//
//  ChannelTableViewCell.h
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ChannelCellTitle;
- (NSString *)cellName;
- (NSString *)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
