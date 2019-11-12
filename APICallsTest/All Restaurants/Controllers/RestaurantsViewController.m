//
//  RestaurantsViewController.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "RestaurantsViewController.h"

@interface RestaurantsViewController ()

@end

@implementation RestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _restaurantView = (RestaurantsView *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantsView" owner:self options:nil] objectAtIndex:0];
    _restaurantView.frame = self.view.bounds;
   _restaurantView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [_restaurantView.restaurantsCollectionView registerNib:[UINib nibWithNibName:@"RestaurantCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RestaurantCell"];
    
    _restaurantView.restaurantsCollectionView.delegate = self;
    _restaurantView.restaurantsCollectionView.dataSource = self;
    
    [self.view addSubview:_restaurantView];
    [self.restaurantView.restaurantsLoader startAnimating];
   [self setHiddenForBarButton:true];
    [self.restaurantView.restaurantsCollectionView setHidden:true];
    [self getAllRestaurantsBasedCategory];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
   [self.restaurantView.noResultMessage setHidden:true];
}

- (void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   [self.restaurantView.noResultMessage setHidden:false];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [_restaurants count];
}
- (IBAction)goToRestaurantsMap:(id)sender {
   
    [self performSegueWithIdentifier:@"MapSegue" sender:self.locationsInfoRestaurants];
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
   __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   activityIndicator.center = cell.restaurantImageView.center;
   activityIndicator.hidesWhenStopped = true;
   [cell.restaurantImageView sd_setImageWithURL:restaurant.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage * image, NSError * error, SDImageCacheType cacheType, NSURL * imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
         [activityIndicator stopAnimating];
         [activityIndicator removeFromSuperview];
      });
   }];
   [cell.restaurantImageView addSubview:activityIndicator];
   [activityIndicator startAnimating];
    cell.restaurantNameLabel.text = restaurant.restaurantName;
    cell.restaurantTimings.text = restaurant.restaurantTiming;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGFloat computedHeight = screenSize.height / 3;
    CGFloat computedWidth = screenSize.width / 3;
    return CGSizeMake(computedWidth, computedHeight);
}

- (void)getAllRestaurantsBasedCategory {
    NSString *restaurantsUrl = @"https://developers.zomato.com/api/v2.1/search";
    NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
    NSDictionary *parameters = @{ @"category":_selectedCategoryID,
                                  @"lat":@"14.219866",
                                  @"lon":@"121.037037",
                                  @"radius":@"2000",
                                  @"sort":@"real_distance",
                                  @"fbclid":@"IwAR0lzrwGrR5glUXZ0FXMtdjKkzex1VGwabCIsGKVFNc-iSvihd6IE3Hetio"
                                  };
    
    _restaurants = [[NSMutableArray alloc] init];
   _locationsInfoRestaurants = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"user-key"];
    [manager GET:restaurantsUrl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
       NSDictionary *responseDictionary = responseObject;
       NSArray *responseArray = responseDictionary[@"restaurants"];
        if (task.state == NSURLSessionTaskStateCompleted)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               if ([responseArray count] == 0)
               {
                  [self.restaurantView.noResultMessage setHidden:false];
               }
               else {
                  [self setHiddenForBarButton:false];
                  [self.restaurantView.restaurantsCollectionView setHidden:false];
                  [self.restaurantView.restaurantsLoader stopAnimating];
                  [self.restaurantView.restaurantsCollectionView reloadData];
               }
            });
        }
      for (id item in responseArray)
        {
            NSDictionary *responseCategoryEnvelop = item[@"restaurant"];
            NSURL *thumbURL = [NSURL URLWithString:responseCategoryEnvelop[@"featured_image"]];
           Restaurant *restaurant = [[Restaurant alloc] initWithImageURL:thumbURL restaurantName:responseCategoryEnvelop[@"name"] restaurantTimings:responseCategoryEnvelop[@"timings"]
               restaurantID:responseCategoryEnvelop[@"id"]];
            [self.restaurants addObject:restaurant];
           NSDictionary *restaurantAddressEnvelop = responseCategoryEnvelop[@"location"];
           NSDictionary *userRatings = responseCategoryEnvelop[@"user_rating"];
           NSDictionary *restaurantLocationInfo = @{ @"name":responseCategoryEnvelop[@"name"],
                                                     @"lat":restaurantAddressEnvelop[@"latitude"],
                                                     @"long":restaurantAddressEnvelop[@"longitude"],
                                                     @"ratings":userRatings[@"aggregate_rating"]
                                                     };
           [self.locationsInfoRestaurants addObject:restaurantLocationInfo];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@",error);
    }];
}

- (void)setHiddenForBarButton:(BOOL)enabled {
   [self.restaurantsMap setEnabled:!enabled];
   [self.restaurantsMap setTintColor: enabled ? [UIColor clearColor] : nil];
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
