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

@interface NetworkController()

@end

@implementation NetworkController

+(NSArray *) parseResponse:(NSData *)responseData andScope:(NSString *)scope {
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
            NSLog([error localizedDescription]);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger responseCode = [httpResponse statusCode];
                switch (responseCode) {
                    case 200:
                        NSLog(@"Everything OK");
                        completionHandler([NetworkController parseResponse:data andScope:scope], nil);
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

@end
