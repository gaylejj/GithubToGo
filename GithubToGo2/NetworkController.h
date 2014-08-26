//
//  NetworkController.h
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+(void)downloadSearchResults:(NSString *)searchterm withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler;

@end
