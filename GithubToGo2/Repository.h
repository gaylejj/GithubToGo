//
//  Repository.h
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

//@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSNumber *repoID;
@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *language;

-(instancetype)initFromDictionary:(NSDictionary *)responseDict;

@end
