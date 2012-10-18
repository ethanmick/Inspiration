//
//  SelectedItemViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/17/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "SelectedItemViewController.h"

@interface SelectedItemViewController ()

- (IBAction)dismissSelectedItemView:(id)sender;


@end

@implementation SelectedItemViewController

- (IBAction)dismissSelectedItemView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.content isKindOfClass:[UIImage class]]) {
        ///
        /// Setup Image
        ///
        UIScrollView *scrollview = [[UIScrollView alloc]
                                    initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:self.content];
        CGSize imageSize = [self.content size];
        image.frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        scrollview.contentSize = imageSize;
        
        ///
        /// Make it in the middle if applicable
        ///
        CGRect imageFrame = image.frame;
        if (imageFrame.size.width < scrollview.frame.size.width) {
            imageFrame.origin.x = (scrollview.frame.size.width - imageFrame.size.width) / 2;
        }
        
        if (imageFrame.size.height < scrollview.frame.size.height) {
            imageFrame.origin.y = ( scrollview.frame.size.height - imageFrame.size.height ) / 2;
        }
        
        image.frame = imageFrame;

        [scrollview addSubview:image];
        [self.view insertSubview:scrollview atIndex:0];
    } else {
        ///
        /// Setup text
        ///
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
        textLabel.text = self.content;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:20];
        [self.view addSubview:textLabel];
    }

}
@end
