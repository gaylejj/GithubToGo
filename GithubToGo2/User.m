//
//  User.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initFromDictionary:(NSDictionary *)responseDict {
    self = [super init];
    
    if (self) {
        self.avatar_url = [responseDict objectForKey:@"avatar_url"];
        self.html_url = [responseDict objectForKey:@"html_url"];
        self.followers_url = [responseDict objectForKey:@"followers_url"];
        self.login = [responseDict objectForKey:@"login"];
    }
    return self;
}

@end
