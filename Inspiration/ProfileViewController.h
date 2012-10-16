//
//  ProfileViewController.h
//  Inspiration
//
//  Created by Ethan Mick on 10/15/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileViewControllerDelegate;

@interface ProfileViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) CMUser *user;
@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;

@end


@protocol ProfileViewControllerDelegate <NSObject>
@optional

- (void)profileControllerDidSelectUser:(CMUser *)aUser;

@end
