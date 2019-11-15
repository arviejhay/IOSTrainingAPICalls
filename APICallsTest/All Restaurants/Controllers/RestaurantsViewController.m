//
//  RestaurantsViewController.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "RestaurantsViewController.h"

@interface RestaurantsViewController ()

- (void)insertRestaurantPrimaryInfoToCollection:(id)currentItem;
- (void)insertRestaurantLocationInfoToCollection:(id)currentItem;
- (void)initializeSDActivityLoaderWithImageURL:(NSURL *)imageURL andRestaurantCell:(RestaurantCollectionViewCell *)cell;

- (void)showAlertWith:(NSString *)message;

@end

@implementation RestaurantsViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   
   [self initializeView];
   
   _restaurants = [[NSMutableArray alloc] init];
   _locationsInfoRestaurants = [[NSMutableArray alloc] init];
   
   [self initializeAPIResourcesWithLatitude:_latitude andWithLongitude:_longitude];
    // Do any additional setup after loading the view.
}

- (void)initializeView {
   NSString *viewName = @"RestaurantsView";
   
   _restaurantView = (RestaurantsView *)[[[NSBundle mainBundle] loadNibNamed:viewName owner:self options:nil] objectAtIndex:0];
   _restaurantView.frame = self.view.bounds;
   _restaurantView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
   
   NSString *cellName = [[RestaurantCollectionViewCell alloc] cellName];
   NSString *reuseIdentifier = [[RestaurantCollectionViewCell alloc] reuseIdentifier];
   
   [_restaurantView.restaurantsCollectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
   
   _restaurantView.restaurantsCollectionView.delegate = self;
   _restaurantView.restaurantsCollectionView.dataSource = self;
   
   [_restaurantView.restaurantsLoader startAnimating];
   [_restaurantView.restaurantsCollectionView setHidden:true];
   
   [self setHiddenForBarButton:true];
   
   [self.view addSubview:_restaurantView];
}

- (void)setHiddenForBarButton:(BOOL)enabled {
   [self.restaurantsMap setEnabled:!enabled];
   [self.restaurantsMap setTintColor: enabled ? [UIColor clearColor] : nil];
}

- (void)initializeAPIResourcesWithLatitude:(NSString *)latitude andWithLongitude:(NSString *)longitude {
   NSString *apiLink = @"https://developers.zomato.com/api/v2.1/search";
   NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
   
   _api = [[APIRetrieval alloc] initWithAPILink:apiLink andAPIKey:apiKey];
   
   NSDictionary *parameters = @{ @"category":_selectedCategoryID,
                                 @"lat":latitude,
                                 @"lon":longitude,
                                 @"radius":@"2000",
                                 @"sort":@"real_distance",
                                 @"fbclid":@"IwAR0lzrwGrR5glUXZ0FXMtdjKkzex1VGwabCIsGKVFNc-iSvihd6IE3Hetio"
                                 };
   
   RestaurantsViewController *rvc = self;
   
   _api.successBlock = ^(NSURLSessionTask * _Nonnull task, id _Nullable responseObject) {
            NSDictionary *responseDictionary = responseObject;
            NSArray *responseRestaurants = responseDictionary[@"restaurants"];
            if (task.state == NSURLSessionTaskStateCompleted)
            {
               dispatch_async(dispatch_get_main_queue(), ^{
                  if ([responseRestaurants count] == 0)
                  {
                     [rvc.restaurantView.noResultMessage setHidden:false];
                     [rvc.restaurantView.restaurantsLoader stopAnimating];
                  }
                  else {
                     [rvc setHiddenForBarButton:false];
                     [rvc.restaurantView.restaurantsCollectionView setHidden:false];
                     [rvc.restaurantView.restaurantsLoader stopAnimating];
                     [rvc.restaurantView.restaurantsCollectionView reloadData];
                  }
               });
            }
            for (id item in responseRestaurants)
            {
               
               [rvc insertRestaurantPrimaryInfoToCollection:item[@"restaurant"]];
               [rvc insertRestaurantLocationInfoToCollection:item[@"restaurant"]];
            }
   };
   
   _api.failureBlock = ^(NSURLSessionTask *operation, NSError *error) {
      NSLog(@"Error: %@",error);
      [rvc showAlertWith:@"Getting Restaurants Data Failed, Please check your internet connection"];
   };
   
   [self retrieveDataWithSuccess:_api.successBlock withFailure:_api.failureBlock withParameters:parameters];
}

- (void)insertRestaurantPrimaryInfoToCollection:(id)currentItem {
   
   RestaurantsViewController *rvc = self;
   
   NSString *featuredImage = currentItem[@"featured_image"];
   
   NSURL *thumbURL = [NSURL URLWithString:featuredImage];
   
   NSString *restaurantName = currentItem[@"name"];
   NSString *restaurantTiming = currentItem[@"timings"];
   NSString *restaurantID = currentItem[@"id"];
   
   Restaurant *restaurant = [[Restaurant alloc] initWithImageURL:thumbURL restaurantName:restaurantName
                                               restaurantTimings:restaurantTiming
                                                    restaurantID:restaurantID];
   [rvc.restaurants addObject:restaurant];
}

- (void)insertRestaurantLocationInfoToCollection:(id)currentItem {
   
   RestaurantsViewController *rvc = self;
   
   NSString *restaurantName = currentItem[@"name"];
   
   NSDictionary *restaurantAddress = currentItem[@"location"];
   
   NSString *restaurantLatitude = restaurantAddress[@"latitude"];
   NSString *restaurantLongitude = restaurantAddress[@"longitude"];
   
   NSDictionary *userRatings = currentItem[@"user_rating"];
   
   NSString *ratings = userRatings[@"aggregate_rating"];
   
   NSDictionary *restaurantLocationInfo = @{ @"name":restaurantName,
                                             @"lat":restaurantLatitude,
                                             @"long":restaurantLongitude,
                                             @"ratings":ratings
                                             };
   
   [rvc.locationsInfoRestaurants addObject:restaurantLocationInfo];
}

- (void)retrieveDataWithSuccess:(success)successBlock withFailure:(failure)failureBlock withParameters:(NSDictionary *)dictionary {
   
   [_api initAFNetworkingObject];
   [_api.sessionManager GET:_api.apiLink parameters:dictionary progress:nil success:successBlock failure:failureBlock];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [_restaurants count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
   Restaurant *selectedRestaurant = _restaurants[indexPath.item];
   
   NSDictionary *restaurantInfo = [[NSDictionary alloc] init];
   restaurantInfo = @{ @"Name":selectedRestaurant.restaurantName,
                       @"Thumb":selectedRestaurant.imageURL,
                       @"Timings":selectedRestaurant.restaurantTiming,
                       @"ID":selectedRestaurant.restaurantID };
   [self performSegueWithIdentifier:@"SelectedRestaurantSegue" sender:restaurantInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([segue.identifier isEqualToString:@"SelectedRestaurantSegue"]) {
      SelectedRestaurantViewController *srvc = [segue destinationViewController];
      NSDictionary *info = (NSDictionary *)sender;
      srvc.selectedRestaurantInfo = info;
      srvc.selectedNavigationTitle.title = info[@"Name"];
   }
   else if ([segue.identifier isEqualToString:@"MapSegue"]) {
      UINavigationController *naviCon = [segue destinationViewController];
      RestaurantsMapViewController *rmvc = naviCon.viewControllers[0];
      rmvc.listOfRestaurantsCoordinates = (NSMutableArray *)sender;
      
   }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantCollectionViewCell *cell = [_restaurantView.restaurantsCollectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantCell" forIndexPath:indexPath];
    
    Restaurant *restaurant = _restaurants[indexPath.item];
    [self initializeSDActivityLoaderWithImageURL:restaurant.imageURL andRestaurantCell:cell];
    cell.restaurantNameLabel.text = restaurant.restaurantName;
    cell.restaurantTimings.text = restaurant.restaurantTiming;
    return cell;
}

- (void)initializeSDActivityLoaderWithImageURL:(NSURL *)imageURL andRestaurantCell:(RestaurantCollectionViewCell *)cell{
   __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   activityIndicator.center = cell.restaurantImageView.center;
   activityIndicator.hidesWhenStopped = true;
   [cell.restaurantImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
         [activityIndicator stopAnimating];
         [activityIndicator removeFromSuperview];
      });
   }];
   [activityIndicator startAnimating];
   [cell.restaurantImageView addSubview:activityIndicator];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
   
    int numberOfItemsRendered = 3;
   
    CGFloat preferredHeight = 251;
    CGFloat computedWidth = screenSize.width / numberOfItemsRendered;
   
   return CGSizeMake(computedWidth, preferredHeight);
}

- (IBAction)backToCategories:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)goToRestaurantsMap:(id)sender {
   
   [self performSegueWithIdentifier:@"MapSegue" sender:self.locationsInfoRestaurants];
}

- (void)viewWillAppear:(BOOL)animated {
   [self.restaurantView.noResultMessage setHidden:true];
}

- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   [self.restaurantView.noResultMessage setHidden:false];
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
