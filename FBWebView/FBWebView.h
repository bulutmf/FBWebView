//  FBWebView.m
//  Created by Fatih Bulut on 8/16/12. http://fatih-bulut.blogspot.com
//  Copyright (c) 2012 -fatih bulut-. All rights reserved.

#import <UIKit/UIKit.h>

@interface FBWebView : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void) setLinkUrl:(NSString *) link_;
- (IBAction) actinForWebPage:(id)sender;

@end
