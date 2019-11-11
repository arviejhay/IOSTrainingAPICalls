//
//  HomeViewController.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Views/HomeView.h"
#import "../Models/Category.h"
#import "../Views/Cells/HomeTableViewCell.h"
#import "../../All Restaurants/Controllers/RestaurantsViewController.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) HomeView *homeView;
@property(copy, readwrite) NSMutableArray *categories;
- (void)getCategories;

@end

NS_ASSUME_NONNULL_END
