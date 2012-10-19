//
//  AppDelegate.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "AppDelegate.h"
#import <CloudMine/CloudMine.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ///
    /// Setup Cloudmine
    ///
    [[CMAPICredentials sharedInstance] setAppIdentifier:@"6a13f176e3364519886b095830028dad"];
    [[CMAPICredentials sharedInstance] setAppSecret:@"fb96d6102a4b4fb2980266c4b3f97973"];
    
    return YES;
}

@end
