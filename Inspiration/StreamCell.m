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

- (void)reset {
    [self.textLabel removeFromSuperview];
    [self.image removeFromSuperview];
}

- (void)configureAsText:(StreamText *)text {
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
    self.textLabel.text = text.text;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.textLabel];
}


- (void)configureAsPicture:(StreamPicture *)pic {
    self.image = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
    self.image.image = pic.image;
    [self.contentView addSubview:self.image];
}


@end
