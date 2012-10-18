//
//  StreamItem.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamItem.h"

@implementation StreamItem

@synthesize typeOfItem = _typeOfItem;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_typeOfItem forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if ((self = [super initWithCoder:aCoder])) {
        _typeOfItem = [aCoder decodeObjectForKey:@"type"];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [self.objectId isEqual:((StreamItem *)object).objectId];
}

- (id)getContent {
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return nil;
}

- (void)saveItem {}
- (void)saveItemWithUser:(CMUser *)user {}
- (void)downloadContent {}

@end
