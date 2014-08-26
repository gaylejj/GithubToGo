//
//  NetworkController.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "NetworkController.h"
#import "Repository.h"

@interface NetworkController()

@end

@implementation NetworkController

+(NSArray *) parseResponse:(NSData *)responseData {
    NSMutableArray *repositories = [[NSMutableArray alloc]init];

    
    NSError *error = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray *jsonArray = responseDict[@"items"];

    for (NSDictionary *repoDict in jsonArray) {
        
        Repository *repo = [[Repository alloc]initFromDictionary:repoDict];
        [repositories addObject:repo];
        
    }
    
    return repositories;
}

+(void)downloadSearchResults:(NSString *)searchterm withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler {
    
    NSString *prefixURL = (@"https://api.github.com/search/repositories?&sort=stars&order=desc&q=");
    NSString *termURL = (@"%@", searchterm);
    NSString *urlString = [prefixURL stringByAppendingString:termURL];
    
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
                        completionHandler([NetworkController parseResponse:data], nil);
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
