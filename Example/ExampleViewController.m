//
//  ExampleViewController.m
//  PWWebViewController
//
//  Created by Matthias Plappert on 24.10.09.
//  Copyright 2009 phapswebsolutions. All rights reserved.
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
    return 2;
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
			cell.textLabel.text = @"Show Modal with UINavigationController";
			break;
		case 1:
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
		case 1:
			[self.navigationController pushViewController:webController animated:YES];
			break;
	}
	
	[webController release];
}
																																										  
#pragma mark -
#pragma mark Actions
																																										  
- (void)dismissModal
{
	[self.modalViewController dismissModalViewControllerAnimated:YES];
}

@end

