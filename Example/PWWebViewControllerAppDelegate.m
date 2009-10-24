//
//  PWWebViewControllerAppDelegate.m
//  PWWebViewController
//
//  Created by Matthias Plappert on 24.10.09.
//  Copyright phapswebsolutions 2009. All rights reserved.
//

#import "PWWebViewControllerAppDelegate.h"
#import "ExampleViewController.h"

@implementation PWWebViewControllerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	ExampleViewController *controller = [[ExampleViewController alloc] init];
	navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc
{
    [window release];
	[navigationController release];
	
    [super dealloc];
}

@end
