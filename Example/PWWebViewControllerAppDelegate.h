//
//  PWWebViewControllerAppDelegate.h
//  PWWebViewController
//
//  Created by Matthias Plappert on 24.10.09.
//  Copyright phapswebsolutions 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWWebViewControllerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

