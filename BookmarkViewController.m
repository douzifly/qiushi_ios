//
//  BookmarkViewController.m
//  Funny
//
//  Created by 小 元 on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookmarkViewController.h"
#import "DataStore.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController
@synthesize toolBtnDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSMutableArray *storedData = [DataStore readData];
    NSLog(@"read stored data ,count : %d", [storedData count]);
    
}

- (void)viewDidUnload
{
    [self setToolBtnDone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [toolBtnDone release];
    [super dealloc];
}
- (IBAction)toolBtnDoneAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
