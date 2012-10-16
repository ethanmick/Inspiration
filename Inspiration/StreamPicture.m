//
//  StreamPicture.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamPicture.h"

@implementation StreamPicture

@synthesize imageName = _imageName;
@synthesize image;

- (id)init {
    if ( (self = [super init]) ) {
        self.typeOfItem = @"picture";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_imageName forKey:@"imageName"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if ((self = [super initWithCoder:aCoder])) {
        _imageName = [aCoder decodeObjectForKey:@"imageName"];
    }
    return self;
}

@end
