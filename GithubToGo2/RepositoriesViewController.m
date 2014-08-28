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
@property (strong, nonatomic) NSMutableArray *myRepositories;
@property (strong, nonatomic) UIBarButtonItem *createRepoButton;
@property (strong, nonatomic) NetworkController *appDelegateNetworkController;
@property (strong, nonatomic) UIAlertController *createAlertView;

@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.networkController.delegate = self;
    self.appDelegateNetworkController = appDelegate.networkController;
    
//    self.navigationController.title = @"My Repositories";
    self.title = @"My Repositories";
    
    self.createRepoButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(setupCreateAlertView)];
    self.navigationItem.rightBarButtonItem = self.createRepoButton;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
/*    
 self.oAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:GITHUB_TOKEN_KEY];
    if (!self.oAuthToken) {
        NSString * authURL = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_REDIRECT, @"user,repo"];
        NSLog(@"%@",authURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } else {
        [self.delegate didAuthenticate];
    }
 */
    [self.appDelegateNetworkController beginOAuth];

}

-(void)setupCreateAlertView {
    self.createAlertView = [UIAlertController alertControllerWithTitle:@"Create a Repo" message:@"Enter a name for your repo below" preferredStyle:UIAlertControllerStyleAlert];
    [self.createAlertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.adjustsFontSizeToFitWidth = true;
        textField.placeholder = @"Repo Name Here";
    }];

    UIAlertAction *createButton = [UIAlertAction actionWithTitle:@"Create Repo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createRepoForUser];
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self.createAlertView addAction:createButton];
    [self.createAlertView addAction:cancelButton];
    [self presentViewController:self.createAlertView animated:true completion:nil];
}

-(void)createRepoForUser {
    [self.appDelegateNetworkController createRepoWithName:@"Test"];
    [self.appDelegateNetworkController fetchUserReposAndFollowers];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repos" forIndexPath:indexPath];
    
    Repository *repo = self.myRepositories[indexPath.row];
    
    cell.textLabel.text = repo.full_name;
    cell.detailTextLabel.text = repo.language;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRepositories.count;
}

-(void)reposFinishedParsing:(NSArray *)jsonArray {
    NSMutableArray *repos = [[NSMutableArray alloc]init];
    
    for (NSDictionary *repoDict in jsonArray) {
        Repository *repo = [[Repository alloc]initFromDictionary:repoDict];
        [repos addObject:repo];
    }
    
    self.myRepositories = repos;
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        self.tableView.hidden = false;
        
        [self.tableView reloadData];
    }];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
