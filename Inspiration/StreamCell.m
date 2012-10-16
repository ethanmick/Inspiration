//
//  StreamCell.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamCell.h"
#import "StreamPicture.h"
#import "StreamText.h"

@implementation StreamCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configureAsText:(StreamText *)text {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
    textLabel.text = text.text;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:textLabel];
}


- (void)configureAsPicture:(StreamPicture *)pic {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
    image.image = pic.image;
    [self.contentView addSubview:image];
}


@end
