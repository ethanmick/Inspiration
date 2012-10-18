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

@synthesize textView, globalStream;

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
    if (self.globalStream) {
        [newText saveItem];
    }
    
    
    CMUser *user = [[CMStore defaultStore] user];
    
    if (user.isLoggedIn) {
        StreamText *copyText = [newText copy];
        [copyText saveItemWithUser:user];
    }
}



@end
