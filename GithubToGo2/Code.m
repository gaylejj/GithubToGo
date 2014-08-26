//
//  Code.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "Code.h"

@implementation Code

-(instancetype)initFromDictionary:(NSDictionary *)responseDict {
    self = [super init];
    
    if (self) {
        self.name = [responseDict objectForKey:@"name"];
        self.html_url = [responseDict objectForKey:@"html_url"];
    }
    return self;
}

@end
