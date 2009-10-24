//
//  PWWebViewController.h
//  PWWebViewController
//
//  Created by Matthias Plappert on 24.10.09.
//  Copyright 2009 phapswebsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

// You can use this to identify a action sheet tag that was created by PWWebViewController
#define kPWWebViewControllerActionSheetTag         5000

// The index of the mail action
#define kPWWebViewControllerActionSheetMailIndex   1

// The index of the open in safari action
#define kPWWebViewControllerActionSheetSafariIndex 0

@interface PWWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	// The web view
	UIWebView *_webView;
	
	// Toolbar and used buttons
	UIToolbar *_toolbar;
	UIBarButtonItem *_actionButton;
	UIBarButtonItem *_reloadButton;
	UIBarButtonItem *_loadingButton;
	UIBarButtonItem *_forwardButton;
	UIBarButtonItem *_backButton;
	UIBarButtonItem *_flexibleSpace;
	
	/* This is used to store the request if the view is loaded.
	   Important if view was released because of low memory conditions */
	NSURLRequest *_request;
}

/* Readonly property to access the UIWebView.
   However, you should use this only to retreive values from the web view */
@property (nonatomic, readonly) UIWebView *webView;

// Use this method to init the web view controller
- (id)initWithRequest:(NSURLRequest *)request;

// Shows all available actions in a UIActionSheet that can be performed on the current page
- (void)showAvailableActions;

// Reloads the current website
- (void)reload;

// Go one site back, if available
- (void)goBack;

// Go on site forward, if available
- (void)goForward;

@end
