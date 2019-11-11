//
//  SelectedRestaurantViewController.m
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "SelectedRestaurantViewController.h"

@interface SelectedRestaurantViewController ()

@end

@implementation SelectedRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedRestaurantView = (SelectedRestaurantView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectedRestaurantView" owner:self options:nil] objectAtIndex:0];
    _selectedRestaurantView.frame = self.view.frame;
    
    [self.view addSubview:_selectedRestaurantView];
    [self.selectedRestaurantView.restaurantInfoLoader startAnimating];
    [self getRestaurantByID];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.selectedRestaurantView.selectedRestaurantInfoBottom setHidden:true];
}

- (void)loadSelectedRestaurantInfo {
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.selectedRestaurantView.restaurantImageView.center;
    activityIndicator.hidesWhenStopped = true;
    [self.selectedRestaurantView.restaurantImageView sd_setImageWithURL:self.selectedRestaurant.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
    }];
    [self.selectedRestaurantView.restaurantImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    self.selectedRestaurantView.restaurantNameLabel.text = self.selectedRestaurant.restaurantName;
    self.selectedRestaurantView.restaurantTimingsLabel.text = self.selectedRestaurant.restaurantTiming;
    self.selectedRestaurantView.restaurantIDLabel.text = self.selectedRestaurant.restaurantID;
    self.selectedRestaurantView.restaurantAddressLabel.text = self.selectedRestaurant.restaurantAddress;
    self.selectedRestaurantView.restaurantRatingsLabel.text = [NSString stringWithFormat:@"%d",self.selectedRestaurant.restaurantRatings];
    self.selectedRestaurantView.restaurantCuisinesLabel.text = self.selectedRestaurant.restaurantCuisines;
    self.selectedRestaurantView.restaurantAverageLabel.text = [NSString stringWithFormat:@"P%d",self.selectedRestaurant.restaurantAverageForTwo];

}

- (void)getRestaurantByID {
    NSString *restaurantsUrl = @"https://developers.zomato.com/api/v2.1/search";
    NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
    NSDictionary *parameters = @{ @"res_id":_selectedRestaurantInfo[@"ID"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"user-key"];
    [manager GET:restaurantsUrl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        NSArray *responseArray = responseDictionary[@"restaurants"];
        NSDictionary *responseDictionaryInner = responseArray[0];
        NSDictionary *responseDictionaryRestaurant = responseDictionaryInner[@"restaurant"];
        NSDictionary *locationInfo = responseDictionaryRestaurant[@"location"];
        NSDictionary *userRating = responseDictionaryRestaurant[@"user_rating"];
        
        NSDictionary *restaurantInfoFinal = @{ @"thumb":self.selectedRestaurantInfo[@"Thumb"],
                                               @"name": self.selectedRestaurantInfo[@"Name"],
                                               @"timings": self.selectedRestaurantInfo[@"Timings"],
                                               @"id":self.selectedRestaurantInfo[@"ID"],
                                               @"address":locationInfo[@"address"],
                                               @"ratings":userRating[@"aggregate_rating"],
                                               @"cuisines":responseDictionaryRestaurant[@"cuisines"],
                                               @"averageForTwo":responseDictionaryRestaurant[@"average_cost_for_two"]};
        
        self.selectedRestaurant = [[SelectedRestaurant alloc] initWithRestaurantInfoDictionary:restaurantInfoFinal];
        
        if (task.state == NSURLSessionTaskStateCompleted)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.selectedRestaurantView.restaurantInfoLoader stopAnimating];
                [self.selectedRestaurantView.selectedRestaurantInfoBottom setHidden:false];
                [self loadSelectedRestaurantInfo];
            });
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@",error);
    }];

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
