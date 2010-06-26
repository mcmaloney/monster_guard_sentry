//
//  CGImage_TestAppDelegate.h
//  CGImage Test
//
//  Created by Michael Maloney on 6/23/10.
//  Copyright Carlson Shepherd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGImage_TestViewController;

@interface CGImage_TestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CGImage_TestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CGImage_TestViewController *viewController;

@end

