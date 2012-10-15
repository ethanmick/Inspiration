//
//  StreamItem.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamItem.h"

@implementation StreamItem

@synthesize type = _type;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if ((self = [super initWithCoder:aCoder])) {
        _type = [aCoder decodeObjectForKey:@"type"];
    }
    return self;
}

@end
