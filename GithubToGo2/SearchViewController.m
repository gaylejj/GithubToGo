//
//  SearchViewController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkController.h"
#import "Repository.h"
#import "Code.h"
#import "User.h"

@interface SearchViewController () <UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *results;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    
    
    
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        Repository *result = self.results[indexPath.row];
        if (result) {
            cell.textLabel.text = result.name;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }    } else if (self.searchBar.selectedScopeButtonIndex == 1) {
        Code *result = self.results[indexPath.row];
        if (result) {
            cell.textLabel.text = result.name;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    } else {
        User *result = self.results[indexPath.row];
        if (result) {
            cell.textLabel.text = result.html_url;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    }
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    [searchBar resignFirstResponder];
    
    if (searchBar.selectedScopeButtonIndex == 0) {
        NSString *repositories = @"repositories";
        [NetworkController downloadSearchResults:searchTerm forScope:repositories withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _results = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [self.tableView reloadData];
            }];
        }];
    } else if (searchBar.selectedScopeButtonIndex == 1) {
        NSString *code = @"code";
        [NetworkController downloadSearchResults:searchTerm forScope:code withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _results = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [self.tableView reloadData];
            }];
        }];
    } else {
        NSString *users = @"users";
        [NetworkController downloadSearchResults:searchTerm forScope:users withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _results = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [self.tableView reloadData];
            }];
        }];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
