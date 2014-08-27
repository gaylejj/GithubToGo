//
//  NetworkController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "NetworkController.h"
#import "Repository.h"
#import "Code.h"
#import "User.h"
#import "Constants.h"

@interface NetworkController()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSString *token;

@end

@implementation NetworkController

-(instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

+(NSArray *) parseSearchResponse:(NSData *)responseData andScope:(NSString *)scope {
    NSMutableArray *response = [[NSMutableArray alloc]init];

    
    NSError *error = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray *jsonArray = responseDict[@"items"];

    for (NSDictionary *resultDict in jsonArray) {
        
        if ([scope isEqualToString:@"repositories"])  {
            Repository *repo = [[Repository alloc]initFromDictionary:resultDict];
            [response addObject:repo];
        } else if ([scope isEqualToString:@"code"]) {
            Code *code = [[Code alloc]initFromDictionary:resultDict];
            [response addObject:code];
        } else {
            User *user = [[User alloc]initFromDictionary:resultDict];
            [response addObject:user];
        }

    }
    
    return response;
}

+(void)downloadSearchResults:(NSString *)searchterm forScope:(NSString *)scope withCompletion:(void(^)(NSArray *results, NSString *errorDescription))completionHandler {
    
    NSString *prefixURL = (@"https://api.github.com/search/");
    NSString *scopeInput = (@"%@", scope);
    NSString *parameters = [[NSString alloc] init];
    
    if ([scope isEqualToString:@"repositories"]) {
        parameters = (@"?&order=desc&sort=stars");
    } else if ([scope isEqualToString:@"code"]) {
        parameters = (@"?&order=desc&sort=indexed");
    } else {
        parameters = (@"?&order=desc&sort=followers");
    }
    
    NSString *termURL = ([@"&q=" stringByAppendingString:(@"%@", searchterm)]);
    NSString *newtermURL = [termURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    // https://api.github.com/search/repositories?&sort=stars&order=desc&q=swift
    
    NSString *urlString = [[[prefixURL stringByAppendingString:scopeInput]
                            stringByAppendingString:parameters]
                           stringByAppendingString:newtermURL];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"General Error");
            NSLog(@"%@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger responseCode = [httpResponse statusCode];
                switch (responseCode) {
                    case 200:
                        NSLog(@"Everything OK");
                        completionHandler([NetworkController parseSearchResponse:data andScope:scope], nil);
                        break;
                    case 404:
                        NSLog(@"Not ok");
                        completionHandler(nil, @"404 not found");
                    default:
                        break;
                }
            } else {
                NSLog(@"Invalid Response Object: %@", response);
                completionHandler(nil, @"5xx Unknown Server Error");
            }
        }
    }];
    [dataTask resume];
}

-(void)handleCallbackURL:(NSURL *)url {
    NSLog(@"%@", url);
    //Parsing URL get back after login
    NSString *query = url.query;
    NSArray *components = [query componentsSeparatedByString:@"code="];
    
    //this is our temp code
    NSString *code = components.lastObject;
    
    //Setting up parameters for POST
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", kGitHubClientID, kGitHubClientSecret, code];
    
    //Convert parameters to data for sending
    NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //Get the length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long) [data length]];
    
    //Creating request for data task
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    
    //Set a bunch of request properties
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    
    //Need lenth of data posting
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //Tell it the type of data
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:data];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
            self.token = [self convertDataToToken: data];
            NSLog(@"%@", self.token);
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            [configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@", self.token]}];
            self.session = [NSURLSession sessionWithConfiguration:configuration];
            [self fetchUserReposAndFollowers];
        }
        
    }] resume];
    
}

-(NSString *)convertDataToToken:(NSData *)data {
    //parsing data we got back, turning it into string first
    NSString *response = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    
    //cutting in half at &
    NSArray *tokenComponents = [response componentsSeparatedByString:@"&"];
    NSString *tokenWithCode = tokenComponents[0];
    
    //cut in half again at =
    NSArray *tokenArray = [tokenWithCode componentsSeparatedByString:@"="];
    return tokenArray.lastObject;
}

-(void)fetchUserReposAndFollowers {
    
    NSURL *repoURL = [[NSURL alloc]initWithString:@"https://api.github.com/user/repos?sort=pushed"];
    NSURL *followerURL = [[NSURL alloc]initWithString:@"https://api.github.com/user/followers"];
    NSLog(@"%@", self.session.configuration.HTTPAdditionalHeaders);
    [[self.session dataTaskWithURL:repoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
        }
        NSArray *reposJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reposFinishedParsing:)]) {
            [self.delegate reposFinishedParsing:reposJson];
        }
    }] resume];
    
    [[self.session dataTaskWithURL:followerURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
        }
        NSArray *followersJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(followersFinishedParsing:)]) {
            [self.delegate followersFinishedParsing:followersJson];
        }
    }] resume];
}

@end
