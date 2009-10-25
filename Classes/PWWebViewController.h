//
//  PWWebViewController.h
//  PWWebViewController
//  
//  Copyright (c) 2009 Matthias Plappert <mplappert@phaps.de>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//  to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

/* Read only property to access the UIWebView.
   However, you should use this only to retrieve values from the web view */
@property (nonatomic, readonly) UIWebView *webView;

// Read only property to access the UIToolbar. You can use this to adjust the appearance of the toolbar. 
@property (nonatomic, readonly) UIToolbar *toolbar;

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
