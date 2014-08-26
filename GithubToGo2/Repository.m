//
//  Repository.m
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/25/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(Repository *)initFromDictionary:(NSDictionary *)responseDict {
    
    self = [super init];
    
    if (self) {
        self.name = [responseDict objectForKey:@"name"];
        self.html_url = [responseDict objectForKey:@"html_url"];
        self.repoID = [responseDict objectForKey:@"id"];
    }
    return self;

}

@end

//init(itemDict: NSDictionary) {
//    self.questionTitle = itemDict.objectForKey("title") as? String
//    self.questionID = itemDict.objectForKey("quesiton_id") as? Int
//    self.questionViewCount = itemDict.objectForKey("view_count") as? Int
//    self.questionAnswerCount = itemDict.objectForKey("answer_count") as? Int
//    if let creationDateEpoch = itemDict.objectForKey("creation_date") as? Double {
//        self.questionCreationDate = NSDate(timeIntervalSince1970: creationDateEpoch)
//    }
//    if let lastActivityDateEpoch = itemDict.objectForKey("last_activity_date") as? Double {
//        self.questionLastActivityDate = NSDate(timeIntervalSince1970: lastActivityDateEpoch)
//    }
//    self.tags = itemDict.objectForKey("tags") as? [String]
//    self.link = itemDict.objectForKey("link") as? String
//}
