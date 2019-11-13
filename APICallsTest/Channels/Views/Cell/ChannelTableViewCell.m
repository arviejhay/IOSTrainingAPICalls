//
//  ChannelTableViewCell.m
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "ChannelTableViewCell.h"

@implementation ChannelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)cellName {
    return @"ChannelTableViewCell";
}

- (NSString *)reuseIdentifier {
    return @"ChannelCell";
}

@end
