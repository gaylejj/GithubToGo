//
//  UserViewController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/26/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "UserViewController.h"
#import "NetworkController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Constants.h"

@interface UserViewController () <NetworkControllerDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *userFollowers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NetworkController *appDelegateNetworkController;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.networkController.delegate = self;
    self.appDelegateNetworkController = appDelegate.networkController;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.appDelegateNetworkController beginOAuth];
//    if (self.userFollowers == nil) {
//        NSString *urlString = [NSString stringWithFormat:kGitHubOAuthURL, kGitHubClientID, kGitHubCallbackURI, @"user,repo"];
//        NSLog(@"%@", urlString);
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
//    }
}

-(void)followersFinishedParsing:(NSArray *)jsonArray {
    NSMutableArray *followers = [[NSMutableArray alloc]init];
    
    for (NSDictionary *followerDict in jsonArray) {
        User *follower = [[User alloc]initFromDictionary:followerDict];
        [followers addObject:follower];

    }
    self.userFollowers = followers;
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"follower" forIndexPath:indexPath];
    
    User *follower = self.userFollowers[indexPath.row];
    cell.textLabel.text = follower.avatar_url;
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    cell.imageView.image = follower.avatarImage;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userFollowers.count;
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
