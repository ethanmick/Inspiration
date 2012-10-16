//
//  SimpleKeychain.h
//  Inspiration
//
//  Created by Ethan Mick on 10/16/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleKeychainUserPass;

@interface SimpleKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end