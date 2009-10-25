//
//  PWWebViewController.m
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

#import "PWWebViewController.h"

@interface PWWebViewController (Private)

// This is used internally to check if the forward/back buttons are enabled
- (void)checkNavigationStatus;

@end


@implementation PWWebViewController

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        _request = [request retain];
		self.hidesBottomBarWhenPushed = YES;
		
		// Create toolbar (to make sure that we can access it at any time)
		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)loadView
{
	// Loads correctly setup view. We setup the view in portrait mode and it get's transformed by the auto resizing.
	[super loadView];
	
	// Get frames
	CGRect frame = self.view.bounds;
	
	// Load web view
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 44.0)];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
	_webView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
								 UIViewAutoresizingFlexibleWidth |
								 UIViewAutoresizingFlexibleRightMargin | 
								 UIViewAutoresizingFlexibleTopMargin |
								 UIViewAutoresizingFlexibleHeight |
								 UIViewAutoresizingFlexibleBottomMargin);
	[self.view addSubview:_webView];
	
	// Load content of web view
	[_webView loadRequest:_request];
	
	// Create action button. This shows a selection of available actions in context of the displayed page
	_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																  target:self
																  action:@selector(showAvailableActions)];
	
	// Create reload button to reload the current page
	_reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																   target:self
																   action:@selector(reload)];
	
	// Create loading button that is displayed if the web view is loading anything
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView startAnimating];
	_loadingButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
	[activityView release];
	
	// Shows the next page, is disabled by default. Web view checks if it can go forward and disables the button if neccessary
	_forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PWWebViewControllerArrowRight.png"] style:UIBarButtonItemStylePlain
													 target:self
													 action:@selector(goForward)];
	_forwardButton.enabled = NO;
	
	// Shows the last page, is disabled by default. Web view checks if it can go back and disables the button if neccessary
	_backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PWWebViewControllerArrowLeft.png"] style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(goBack)];
	_backButton.enabled = NO;
	
	// Setup toolbar
	_toolbar.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height - 44.0, frame.size.width, 44.0);
	_toolbar.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
								 UIViewAutoresizingFlexibleWidth |
								 UIViewAutoresizingFlexibleRightMargin | 
								 UIViewAutoresizingFlexibleTopMargin |
								 UIViewAutoresizingFlexibleHeight |
								 UIViewAutoresizingFlexibleBottomMargin);
	[self.view addSubview:_toolbar];
	
	// Flexible space
	_flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	
	// Assign buttons to toolbar
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload
{
	// Save last request
	[_request release];
	_request = [_webView.request retain];
	
	[_webView release];
	_webView = nil;
	
	[_actionButton release];
	_actionButton = nil;
	
	[_reloadButton release];
	_reloadButton = nil;
	
	[_loadingButton release];
	_loadingButton = nil;
	
	[_forwardButton release];
	_forwardButton = nil;
	
	[_backButton release];
	_backButton = nil;
	
	[_flexibleSpace release];
	_flexibleSpace = nil;
}

- (void)dealloc
{
	[_webView release];
	
	[_request release];
	
	[_toolbar release];
	[_actionButton release];
	[_reloadButton release];
	[_loadingButton release];
	[_forwardButton release];
	[_backButton release];
	[_flexibleSpace release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (UIWebView *)webView
{
	return _webView;
}

- (UIToolbar *)toolbar
{
	return _toolbar;
}

#pragma mark -
#pragma mark Button actions

- (void)showAvailableActions
{
	// Create action sheet without any buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.webView.request.URL absoluteString]
															 delegate:self
													cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	// Add buttons
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
	
	if ([MFMailComposeViewController canSendMail]) {
		// The iPhone/iPod touch is ready to send mails. If it is not, do not add the mail link button
		[actionSheet addButtonWithTitle:NSLocalizedString(@"Mail Link", nil)];
	}
	
	// Add cancel button and mark is as cancel button
	[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
	
	// Assign tag, show it from toolbar and release it
	actionSheet.tag = kPWWebViewControllerActionSheetTag;
	[actionSheet showFromToolbar:_toolbar];
	[actionSheet release];
}

- (void)reload
{
	[self.webView reload];
}

- (void)goBack
{
	if (self.webView.canGoBack == YES) {
		// We can go back. So make the web view load the previous page.
		[self.webView goBack];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}

- (void)goForward
{
	if (self.webView.canGoForward == YES) {
		// We can go forward. So make the web view load the next page.
		[self.webView goForward];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// Change toolbar items
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _loadingButton, nil];
	
	// Set title
	self.title = NSLocalizedString(@"Loading...", nil);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// Change toolbar items
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
	
	// Set title
	NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	self.title = title;
	
	// Check if forward/back buttons are available
	[self checkNavigationStatus];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// Change toolbar items
	_toolbar.items = [NSArray arrayWithObjects:_actionButton, _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
	
	// Check if forward/back buttons are available
	[self checkNavigationStatus];
	
	// Set title
	self.title = NSLocalizedString(@"Page not found", nil);
	
	// Display an alert view that tells the userr what went wrong.
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection did fail", nil)
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet.tag == kPWWebViewControllerActionSheetTag && buttonIndex != actionSheet.cancelButtonIndex) {
		// It is one of your action sheets and it was not canceled
		if (buttonIndex == kPWWebViewControllerActionSheetSafariIndex) {
			// Open URL in Safari
			[[UIApplication sharedApplication] openURL:self.webView.request.URL];
		} else if (buttonIndex == kPWWebViewControllerActionSheetMailIndex) {
			// Mail URL
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			[controller setMessageBody:[self.webView.request.URL absoluteString] isHTML:NO];
			controller.mailComposeDelegate = self;
			[self presentModalViewController:controller animated:YES];
			[controller release];
		}
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if (result == MFMailComposeResultFailed && error != nil) {
		// There was an error. Display an alert view.
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sending failed", nil)
															message:[error localizedDescription]
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"OK", nil)
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	// Hide controller
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Private methods

- (void)checkNavigationStatus
{
	// Check if we can go forward or back
	_backButton.enabled = self.webView.canGoBack;
	_forwardButton.enabled = self.webView.canGoForward;
}

@end
