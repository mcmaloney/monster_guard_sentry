//
//  CGImage_TestAppDelegate.m
//  CGImage Test
//
//  Created by Michael Maloney on 6/23/10.
//  Copyright Carlson Shepherd 2010. All rights reserved.
//

#import "CGImage_TestAppDelegate.h"
#import "CGImage_TestViewController.h"

@implementation CGImage_TestAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
