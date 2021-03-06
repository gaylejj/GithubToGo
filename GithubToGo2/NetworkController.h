//
//  NetworkController.h
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository.h"

@protocol NetworkControllerDelegate <NSObject>

@optional
-(void)reposFinishedParsing:(NSArray *)jsonArray;
-(void)followersFinishedParsing:(NSArray *)jsonArray;

@end

@interface NetworkController : NSObject

+(void)downloadSearchResults:(NSString *)searchterm forScope:(NSString *)scope withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler;
-(void)handleCallbackURL:(NSURL *)url;
-(void)beginOAuth;
-(void)createRepoWithName:(NSString *)repoName;
-(void)fetchUserReposAndFollowers;

@property (nonatomic, weak) id<NetworkControllerDelegate> delegate;


@end
