//
//  HomeViewController.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _homeView = (HomeView *)[[[NSBundle mainBundle] loadNibNamed:@"HomeView" owner:self options:nil] objectAtIndex:0];
    _homeView.frame =  self.view.frame;
    
    _homeView.homeTableView.delegate = self;
    _homeView.homeTableView.dataSource = self;
    
    [_homeView.homeTableView registerNib:[UINib nibWithNibName:[[HomeTableViewCell alloc]cellName] bundle:nil] forCellReuseIdentifier:[[HomeTableViewCell alloc] reuseIdentifier]];
    
    [self.view addSubview:_homeView];
    [self.homeView.categoriesLoader startAnimating];
    [self.homeView.homeTableView setHidden:true];
    [self getCategories];
    
}

- (void)getCategories {
    NSString *categoriesUrl = @"https://developers.zomato.com/api/v2.1/categories";
    NSString *apiKey = @"6594c38d89f197460bbbdf9b03123d85";
    
    _categories = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"user-key"];
    [manager GET:categoriesUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (task.state == NSURLSessionTaskStateCompleted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.homeView.categoriesLoader stopAnimating];
                [self.homeView.homeTableView setHidden:false];
                [self.homeView.homeTableView reloadData];
            });
        }
        NSDictionary *responseDictionary = responseObject;
        NSArray *responseArray = responseDictionary[@"categories"];
        for (id item in responseArray)
        {
            NSDictionary *responseCategoryEnvelop = item[@"categories"];
            
            Category *category = [[Category alloc] categoryID:[responseCategoryEnvelop[@"id"] intValue] name:responseCategoryEnvelop[@"name"]];
            [self.categories addObject:category];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@",error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[HomeTableViewCell alloc]reuseIdentifier]];
    Category *category = _categories[indexPath.row];
    cell.nameLabel.text = category.categoryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Category *selectedCategory = _categories[indexPath.row];
    NSString *selectedCategoryInfo = [NSString stringWithFormat:@"%d-%@", selectedCategory.categoryID,selectedCategory.categoryName];
    [self performSegueWithIdentifier:@"CategorySegue" sender:selectedCategoryInfo];
    [_homeView.homeTableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CategorySegue"]) {
        NSArray *splitCategory = [[NSArray alloc] init];
        splitCategory = [sender componentsSeparatedByString:@"-"];
        RestaurantsViewController *rvc = [segue destinationViewController];
        rvc.selectedCategoryID = splitCategory[0];
        rvc.selectedCategoryTitle.title = splitCategory[1];
    }
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
