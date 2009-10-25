//
//  ExampleViewController.m
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

#import "ExampleViewController.h"
#import "PWWebViewController.h"

@implementation ExampleViewController

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.title = @"Examples";
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Modal + UINavigationController";
			break;
		case 1:
			cell.textLabel.text = @"Modal + UINavigationController + tintColor";
			break;
		case 2:
			cell.textLabel.text = @"Modal (cannot be closed)";
			break;
		case 3:
			cell.textLabel.text = @"Push to UINavigationController stack";
			break;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.phaps.de"]];
	PWWebViewController *webController = [[PWWebViewController alloc] initWithRequest:request];
	
    switch (indexPath.row) {
		case 0: {
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webController];
			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(dismissModal)];
			webController.navigationItem.leftBarButtonItem = cancelButton;
			[cancelButton release];
			[self presentModalViewController:navigationController animated:YES];
			[navigationController release];
			break;
		}
		case 3:
			[self.navigationController pushViewController:webController animated:YES];
			break;
		case 2:
			[self presentModalViewController:webController animated:YES];
			break;
		case 1: {
			// Create navigation controller and adjust tint color
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webController];
			navigationController.navigationBar.tintColor = [UIColor redColor];
			
			// Create cancel button and assign it
			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																						  target:self
																						  action:@selector(dismissModal)];
			webController.navigationItem.leftBarButtonItem = cancelButton;
			[cancelButton release];
			
			// Adjust toolbar tint color
			webController.toolbar.tintColor = [UIColor redColor];
			
			// Present controller and release it
			[self presentModalViewController:navigationController animated:YES];
			[navigationController release];
			break;
		}
	}
	
	// Release web controller
	[webController release];
}
																																										  
#pragma mark -
#pragma mark Actions
																																										  
- (void)dismissModal
{
	[self.modalViewController dismissModalViewControllerAnimated:YES];
}

@end

