//  FBWebView.m
//  Created by Fatih Bulut on 8/16/12. http://fatih-bulut.blogspot.com
//  Copyright (c) 2012 -fatih bulut-. All rights reserved.

#import "FBWebView.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@implementation FBWebView

@synthesize link, webView, actIndicator, navItem, navigationBar, toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255 green:245.0/255 blue:246.0/255 alpha:1];
    self.navigationBar.tintColor = [UIColor colorWithRed:45.0/255 green:71.0/255 blue:106.0/255 alpha:1];
    self.toolBar.tintColor = [UIColor colorWithRed:45.0/255 green:71.0/255 blue:106.0/255 alpha:1];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *processing = [[UIBarButtonItem alloc] initWithCustomView:self.actIndicator];
    self.navItem.rightBarButtonItem = processing;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:self.link];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
	webView.scalesPageToFit = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView_ {
    [actIndicator startAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (BOOL)webView:(UIWebView *)webView_ shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_ {
	[self.actIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error : %@", error);
    [self.actIndicator stopAnimating];
}

- (void) setLinkUrl:(NSString *) link_ {
    self.link = link_;
}

- (void) refreshView:(id) sender {
    NSURL *url = [NSURL URLWithString:self.link];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
	webView.scalesPageToFit = YES;
}

- (void) back:(id) sender {
    [self dismissModalViewControllerAnimated:YES];
}

/*
 Open link in Safari or Share via smat, twitter or e-mail
 */
- (IBAction) actinForWebPage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:(id)self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open in Safari", @"Tweet link", @"E-mail link", nil];
    @try {
        /*Present from view if there is no tabbar in the current view.
         Otherwise, present from tabbar for cancel button to show up correctly.
         */
        [actionSheet showInView:self.view];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
}

/*
 callback for user's selection of action sheet
 */
- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
    if (index == 0) {//Open in Safari
        NSLog(@"Opening in Safari");
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.link]];
    } else if (index == 1) {//tweet
        NSString *textToSend;
        if (self.link.length > 140)
            textToSend = [self.link substringToIndex:139];
        else
            textToSend = self.link;
        
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        [twitter setInitialText:[NSString stringWithFormat:@"%@ ", textToSend]];
        [self presentModalViewController:twitter animated:YES];
        
        // Called when the tweet dialog has been closed
        twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
        {
            NSString *title = @"Tweet Status";
            NSString *msg;
            if (result == TWTweetComposeViewControllerResultCancelled) {
                msg = @"Tweet compostion was canceled.";
            }
            else if (result == TWTweetComposeViewControllerResultDone) {
                msg = @"Tweet composition completed.";
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:@"Successfully posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            
            
            // Dismiss the controller
            [self dismissModalViewControllerAnimated:YES];
        };
    } else if (index == 2) {
        NSLog(@"E-mail");
        
        if (self.link != nil) {
            MFMailComposeViewController *mailComposer;
            mailComposer  = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = (id) self;
            [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
            [mailComposer setSubject:@""];
            [mailComposer setMessageBody:self.link isHTML:NO];
            [self presentModalViewController:mailComposer animated:YES];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(error)
        NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    
    [self dismissModalViewControllerAnimated:YES];
    return;
}

@end


