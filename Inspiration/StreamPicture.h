//
//  StreamPicture.h
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamItem.h"

@interface StreamPicture : StreamItem

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *image;

@end
