//
//  StreamText.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamText.h"

@implementation StreamText

@synthesize text = _text;

- (id)init {
    if ( (self = [super init]) ) {
        self.typeOfItem = @"text";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_text forKey:@"text"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if ((self = [super initWithCoder:aCoder])) {
        _text = [aCoder decodeObjectForKey:@"text"];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [self.objectId isEqual:((StreamText *)object).objectId];
}

@end
