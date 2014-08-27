//
//  Repository.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(instancetype)initFromDictionary:(NSDictionary *)responseDict {
    
    self = [super init];
    
    if (self) {
//        self.name = [responseDict objectForKey:@"name"];
        self.html_url = [responseDict objectForKey:@"html_url"];
        self.repoID = [responseDict objectForKey:@"id"];
        self.full_name = [responseDict objectForKey:@"full_name"];
        self.language = [responseDict objectForKey:@"language"];
    }
    return self;

}

@end
