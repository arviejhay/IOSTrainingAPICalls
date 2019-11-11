//
//  HomeTableViewCell.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:true];

    // Configure the view for the selected state
}

- (NSString *)cellName {
    return @"HomeTableViewCell";
}

- (NSString *)reuseIdentifier {
    return @"HomeCell";
}

@end
