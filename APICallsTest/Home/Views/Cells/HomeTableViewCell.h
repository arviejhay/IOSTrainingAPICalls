//
//  HomeTableViewCell.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (NSString *)cellName;
- (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
