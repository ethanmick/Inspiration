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

- (void)configureAsText:(StreamText *)text;
- (void)configureAsPicture:(StreamPicture *)pic;

@end
