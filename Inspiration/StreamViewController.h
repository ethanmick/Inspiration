//
//  ViewController.h
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface StreamViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProfileViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) CMUser *user;

@end
