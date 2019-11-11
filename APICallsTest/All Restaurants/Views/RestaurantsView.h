//
//  RestaurantsView.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *restaurantsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *restaurantsLoader;
@property (weak, nonatomic) IBOutlet UILabel *noResultMessage;

@end

NS_ASSUME_NONNULL_END
