//
//  StreamCell.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamCell.h"

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
    
}


- (void)configureAsPicture:(StreamPicture *)pic {
    
}

@end
