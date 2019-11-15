//
//  HomeViewController.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property(copy, readwrite) NSString *latitude;
@property(copy, readwrite) NSString *longitude;

- (void)insertCategoryToCollection:(id)currentItem;
- (void)startLocationServices;
- (void)showAlertWith:(NSString *)message;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startLocationServices];
    [self initializeView];
    
    _categories = [[NSMutableArray alloc] init];
    _hvc = self;
}

- (void)startLocationServices {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self checkLocationAccess];
        [_locationManager requestLocation];
        
    }
}

- (void)checkLocationAccess {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusDenied:
            [_locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestWhenInUseAuthorization];
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"There was an error retrieving your location/%@",error.localizedDescription];
    NSLog(@"Error: %@",msg);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *crnLoc = [locations lastObject];
    _latitude =  [[NSNumber numberWithDouble:crnLoc.coordinate.latitude] stringValue];
    _longitude = [[NSNumber numberWithDouble:crnLoc.coordinate.longitude] stringValue];
    [self initializeAPIResources];
}

- (void)initializeView {
    NSString *viewName = @"HomeView";
    
    _homeView = (HomeView *)[[[NSBundle mainBundle] loadNibNamed:viewName owner:self options:nil] objectAtIndex:0];
    _homeView.frame = self.view.bounds;
    _homeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _homeView.homeTableView.delegate = self;
    _homeView.homeTableView.dataSource = self;
    
    NSString *cellName = [[HomeTableViewCell alloc] cellName];
    NSString *reuseIdentifier = [[HomeTableViewCell alloc] reuseIdentifier];
    
    [_homeView.homeTableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [_homeView.categoriesLoader startAnimating];
    [_homeView.homeTableView setHidden:true];
    
    [self.view addSubview:_homeView];
}

- (void)initializeAPIResources {
    NSString *apiLink = @"https://developers.zomato.com/api/v2.1/categories";
    
    NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
    
    HomeViewController *hvcInner = _hvc;
    
    _api = [[APIRetrieval alloc] initWithAPILink:apiLink andAPIKey:apiKey];
    
    _api.successBlock = ^(NSURLSessionTask * _Nonnull task, id _Nullable responseObject) {
        if (task.state == NSURLSessionTaskStateCompleted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hvcInner.homeView.categoriesLoader stopAnimating];
                [hvcInner.homeView.homeTableView setHidden:false];
                [hvcInner.homeView.homeTableView reloadData];
            });
        }
        NSDictionary *responseDictionary = responseObject;
        NSArray *responseCategoryOuter = responseDictionary[@"categories"];
        for (id category in responseCategoryOuter)
        {
            [hvcInner insertCategoryToCollection:category];
        }
    };
    
    _api.failureBlock = ^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@",error);
        [hvcInner showAlertWith:@"Getting Category Data Failed, Please check your internet connection"];
    };
    
    [self retrieveDataWithSuccess:_api.successBlock withFailure:_api.failureBlock withParameters:nil];
}

- (void)insertCategoryToCollection:(id)currentItem {
    NSDictionary *responseCategory = currentItem[@"categories"];
    
    NSString *categoryID = responseCategory[@"id"];
    NSString *categoryName = responseCategory[@"name"];
    
    Category *category = [[Category alloc] categoryID:[categoryID intValue] name:categoryName];
    
    [_hvc.categories addObject:category];
}

- (void)retrieveDataWithSuccess:(success)successBlock withFailure:(failure)failureBlock withParameters:(NSDictionary *)dictionary {
    
    [_api initAFNetworkingObject];
    [_api.sessionManager GET:_api.apiLink parameters:dictionary progress:nil success:successBlock failure:failureBlock];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger categoriesCount = [_categories count];
    return categoriesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = [[HomeTableViewCell alloc] reuseIdentifier];
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    Category *category = _categories[indexPath.row];
    cell.nameLabel.text = category.categoryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Category *selectedCategory = _categories[indexPath.row];
    NSString *selectedCategoryInfo = [NSString stringWithFormat:@"%d-%@", selectedCategory.categoryID,selectedCategory.categoryName];
    [self performSegueWithIdentifier:@"RestaurantSegue" sender:selectedCategoryInfo];
    [_homeView.homeTableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RestaurantSegue"]) {
        NSArray *splitCategory = [[NSArray alloc] init];
        splitCategory = [sender componentsSeparatedByString:@"-"];
        UINavigationController *navVC = [segue destinationViewController];

        RestaurantsViewController *rvc = navVC.viewControllers[0];
        rvc.selectedCategoryID = splitCategory[0];
        rvc.selectedCategoryTitle.title = splitCategory[1];
        rvc.latitude = _latitude;
        rvc.longitude = _longitude;
    }
}

- (void)showAlertWith:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}


@end
