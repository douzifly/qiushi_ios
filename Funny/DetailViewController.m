//
//  DetailViewController.m
//  Funny
//
//  Created by 小 元 on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DataStore.h"
#import "QSDataMgr.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize lblContent;
@synthesize btnFavorite;
@synthesize btnCopy;
@synthesize indexPath;
@synthesize datas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
     NSLog(@"Detail init");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Actions";
     NSLog(@"Detail load");
    
    NSString* data = ((QSItem *)[datas objectAtIndex:indexPath.row]).Content;
    
    [lblContent setText:data];
}

- (void)viewDidUnload
{
    [self setBtnCopy:nil];
    [self setLblContent:nil];
    [self setBtnFavorite:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
     NSLog(@"Detail unload");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"PrepareForSegue");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [btnCopy release];
    [indexPath release];
    [datas release];
    [lblContent release];
    [btnFavorite release];
    [super dealloc];
}

- (IBAction)btnClick:(id)sender {
    NSLog(@"clicked,row is %d",indexPath.row);
    NSString* data = ((QSItem *)[datas objectAtIndex:indexPath.row]).Content;
    [[UIPasteboard generalPasteboard] setValue:data forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnClickOutside:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnFavoriteClick:(id)sender {
    QSItem *item = (QSItem *)[datas objectAtIndex:indexPath.row];
    NSString* data = item.Content;
    [DataStore saveData:data];
    [self dismissModalViewControllerAnimated:YES];
    
}
@end
