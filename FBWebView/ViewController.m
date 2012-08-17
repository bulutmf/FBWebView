//
//  ViewController.m
//  FBWebView
//
//  Created by muhammed fatih bulut on 8/16/12.
//  Copyright (c) 2012 muhammed fatih bulut. All rights reserved.
//

#import "ViewController.h"
#import "FBWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showWebView:(id)sender {
    
    FBWebView *fb = [[FBWebView alloc] initWithNibName:@"FBWebView" bundle:nil];
    [fb setLink:@"http://fatih-bulut.blogspot.com"];
    [self presentModalViewController:fb animated:YES];
}

@end
