//
//  UserCollectionViewCell.h
//  GithubToGo2
//
//  Created by Jeff Gayle on 8/27/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
