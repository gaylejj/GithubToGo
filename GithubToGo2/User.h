//
//  User.h
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSString *followers_url;
@property (nonatomic) UIImage *avatarImage;

-(instancetype)initFromDictionary:(NSDictionary *)responseDict;


@end
