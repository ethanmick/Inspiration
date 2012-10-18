//
//  AddTextViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/16/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "AddTextViewController.h"
#import "StreamText.h"
#import <QuartzCore/QuartzCore.h>

@interface AddTextViewController ()

@end

@implementation AddTextViewController

@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ///
    /// Save the text to the global stream, and to the user stream if applicable
    ///
    StreamText *newText = [[StreamText alloc] init];
    newText.text = textView.text;
    
    [newText save:^(CMObjectUploadResponse *response) {
        DLog(@"Item Saved? %@", response.uploadStatuses);
    }];
    
    CMUser *user = [[CMStore defaultStore] user];
    
    if (user.isLoggedIn) {
        StreamText *copyText = [[StreamText alloc] init];
        copyText.text = newText.text;
        [copyText saveWithUser:user callback:^(CMObjectUploadResponse *response) {
            DLog(@"Saved With user: %@", response.uploadStatuses);
        }];
    }
    

}



@end
