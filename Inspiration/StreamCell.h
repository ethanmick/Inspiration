//
//  StreamCell.h
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StreamText, StreamPicture;

@interface StreamCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *image;

- (void)configureAsText:(StreamText *)text;
- (void)configureAsPicture:(StreamPicture *)pic;
- (void)reset;

@end
