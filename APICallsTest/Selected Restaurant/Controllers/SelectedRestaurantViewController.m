//
//  SelectedRestaurantViewController.m
//  APICallsTest
//
//  Created by OPS on 10/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "SelectedRestaurantViewController.h"

@interface SelectedRestaurantViewController ()

- (void)initializeSDActivityLoader;
- (void)initializeSelectedRestaurantInfoToView;
- (void)insertRestaurantInfoToInitializeWith:(NSDictionary *)restaurant and:(NSString *)restaurantID;

@end

@implementation SelectedRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
    [self initializeAPIResources];
}

- (void)initializeView {
    _selectedRestaurantView = (SelectedRestaurantView *)[[[NSBundle mainBundle] loadNibNamed:@"SelectedRestaurantView" owner:self options:nil] objectAtIndex:0];
    _selectedRestaurantView.frame = self.view.bounds;
    _selectedRestaurantView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_selectedRestaurantView.restaurantInfoLoader startAnimating];
    
    [self.view addSubview:_selectedRestaurantView];
}

- (void)initializeAPIResources {
    NSString *apiLink = @"https://developers.zomato.com/api/v2.1/search";
    NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
    
    _api = [[APIRetrieval alloc] initWithAPILink:apiLink andAPIKey:apiKey];
    
    NSString *restaurantID = _selectedRestaurantInfo[@"ID"];
    
    NSDictionary *parameters = @{ @"res_id":restaurantID };
    
    SelectedRestaurantViewController *srvc = self;
    
    _api.successBlock = ^(NSURLSessionTask * _Nonnull task, id _Nullable responseObject) {
        NSDictionary *responseDictionary = responseObject;
        
        NSArray *responseRestaurants = responseDictionary[@"restaurants"];
        
        NSDictionary *responseRestaurantsInner = responseRestaurants[0];
        NSDictionary *responseRestaurant = responseRestaurantsInner[@"restaurant"];
        
        [srvc insertRestaurantInfoToInitializeWith:responseRestaurant and:restaurantID];
        
        if (task.state == NSURLSessionTaskStateCompleted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [srvc.selectedRestaurantView.restaurantInfoLoader stopAnimating];
                [srvc.selectedRestaurantView.selectedRestaurantInfoBottom setHidden:false];
                [srvc loadSelectedRestaurantInfo];
            });
        }
    };
    
    _api.failureBlock = ^(NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        NSLog(@"Error: %@",error);
        NSString *errorMessage = [NSString stringWithFormat:@"Getting %@ Information Failed, please check your internet connection",srvc.selectedNavigationTitle.title];
        [srvc showAlertWith:errorMessage];
    };
    
    [self retrieveDataWithSuccess:_api.successBlock withFailure:_api.failureBlock withParameters:parameters];
}

- (void)insertRestaurantInfoToInitializeWith:(NSDictionary *)restaurant and:(NSString *)restaurantID {
    SelectedRestaurantViewController *srvc = self;
    
    NSDictionary *locationInfo = restaurant[@"location"];
    NSDictionary *userRating = restaurant[@"user_rating"];
    
    NSString *thumb = srvc.selectedRestaurantInfo[@"Thumb"];
    NSString *name = srvc.selectedRestaurantInfo[@"Name"];
    NSString *timings = srvc.selectedRestaurantInfo[@"Timings"];
    
    NSString *address = locationInfo[@"address"];
    NSString *ratings = userRating[@"aggregate_rating"];
    NSString *cuisines = restaurant[@"cuisines"];
    NSString *averageForTwo = restaurant[@"average_cost_for_two"];
    
    NSDictionary *restaurantInfoFinal = @{ @"thumb":thumb,
                                           @"name": name,
                                           @"timings": timings,
                                           @"id": restaurantID,
                                           @"address": address,
                                           @"ratings": ratings,
                                           @"cuisines": cuisines,
                                           @"averageForTwo": averageForTwo };
    
    srvc.selectedRestaurant = [[SelectedRestaurant alloc] initWithRestaurantInfoDictionary:restaurantInfoFinal];
}

- (void)retrieveDataWithSuccess:(success)successBlock withFailure:(failure)failureBlock withParameters:(NSDictionary *)dictionary {
    [_api initAFNetworkingObject];
    [_api.sessionManager GET:_api.apiLink parameters:dictionary progress:nil success:successBlock failure:failureBlock];
}

- (void)loadSelectedRestaurantInfo {
    [self initializeSDActivityLoader];
    [self initializeSelectedRestaurantInfoToView];
}

- (void)initializeSDActivityLoader {
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.selectedRestaurantView.restaurantImageView.center;
    activityIndicator.hidesWhenStopped = true;
    [self.selectedRestaurantView.restaurantImageView sd_setImageWithURL:self.selectedRestaurant.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        });
    }];
    [activityIndicator startAnimating];
    [self.selectedRestaurantView.restaurantImageView addSubview:activityIndicator];
}

- (void)initializeSelectedRestaurantInfoToView {
    self.selectedRestaurantView.restaurantNameLabel.text = self.selectedRestaurant.restaurantName;
    self.selectedRestaurantView.restaurantTimingsLabel.text = self.selectedRestaurant.restaurantTiming;
    self.selectedRestaurantView.restaurantIDLabel.text = self.selectedRestaurant.restaurantID;
    self.selectedRestaurantView.restaurantAddressLabel.text = self.selectedRestaurant.restaurantAddress;
    self.selectedRestaurantView.restaurantRatingsLabel.text = [NSString stringWithFormat:@"%d",self.selectedRestaurant.restaurantRatings];
    self.selectedRestaurantView.restaurantCuisinesLabel.text = self.selectedRestaurant.restaurantCuisines;
    self.selectedRestaurantView.restaurantAverageLabel.text = [NSString stringWithFormat:@"P%d",self.selectedRestaurant.restaurantAverageForTwo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.selectedRestaurantView.selectedRestaurantInfoBottom setHidden:true];
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
