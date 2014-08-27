//
//  RepositoriesViewController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/26/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "RepositoriesViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "NetworkController.h"

@interface RepositoriesViewController () <UITableViewDataSource, UITableViewDelegate, NetworkControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NetworkController *networkController;
@property (strong, nonatomic) NSMutableArray *myRepositories;

@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.networkController.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.myRepositories == nil) {
        NSString *urlString = [NSString stringWithFormat:kGitHubOAuthURL, kGitHubClientID, kGitHubCallbackURI, @"user,repo"];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repos" forIndexPath:indexPath];
    
    Repository *repo = self.myRepositories[indexPath.row];
    
    cell.textLabel.text = repo.full_name;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRepositories.count;
}

-(NSArray *)reposFinishedParsing:(NSArray *)jsonArray {
    NSMutableArray *repos = [[NSMutableArray alloc]init];
    
    for (NSDictionary *repoDict in jsonArray) {
        Repository *repo = [[Repository alloc]initFromDictionary:repoDict];
        [repos addObject:repo];
    }
    
    self.myRepositories = repos;
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
    return self.myRepositories;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
