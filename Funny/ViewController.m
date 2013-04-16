//
//  ViewController.m
//  Funny
//
//  Created by 小 元 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "HttpHelper.h"
#import "DataStore.h"
#import "QSDataMgr.h"

#define FONT_SIZE 18.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.f


@implementation ViewController

@synthesize myTableView;
@synthesize myTabBar;
@synthesize dataMgr = _dataMgr;
@synthesize page    = _page;
@synthesize indicator = _indicator;


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setCenter:CGPointMake(160, 208)];
    [self.view addSubview:_indicator];
    NSString *pathIcon0 = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    UITabBarItem* hot = [[UITabBarItem alloc]initWithTitle:@"8hr" image:nil tag:QSCategroy8HR];
    UITabBarItem* new = [[UITabBarItem alloc]initWithTitle:@"New" image:nil tag:QSCategroyNew];
    UITabBarItem* trueth = [[UITabBarItem alloc]initWithTitle:@"Hot" image:nil tag:QSCategroyHot];
    UITabBarItem* cross = [[UITabBarItem alloc]initWithTitle:@"History" image:nil tag:QSCateGroyCross];
    UITabBarItem* favo = [[UITabBarItem alloc]initWithTitle:@"Favorite" image:nil tag:QSCateGroyBookmark];
    NSArray* tabItems = [NSArray arrayWithObjects:hot,new,trueth,cross,favo
                         , nil];
    myTabBar.items = tabItems;
    myTabBar.selectedItem = hot;
    myTabBar.delegate = self;

    
    [hot release];
    [new release];
    [trueth release];
    [cross release];
    [favo release];
    
    _dataMgr = [[QSDataMgr alloc]init];
    [self loadData:QSCategroy8HR loadNextPage:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    NSInteger count =  self.page.data.count;
    NSUInteger currentCategory = (NSUInteger)myTabBar.selectedItem.tag;
    if(currentCategory != QSCateGroyBookmark && self.page.data.count > 0){
        // show "MORE" item except bookmark
        count ++;
    }
    NSLog(@"item count %d", count);
    return count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellIndentifier = @"cell";
    UILabel *label = nil;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil){
        NSLog(@"cell is nil , row : %d",indexPath.row);
        cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:cellIndentifier] autorelease];
        label = [[UILabel alloc]initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [label setTag:1];
        [[cell contentView] addSubview:label];
        [label release];
    }
  
    NSString *text = nil;
    BOOL moreItem = NO;
    if(indexPath.row < _page.data.count){
        QSItem *item = [_page.data objectAtIndex:indexPath.row];
        text = item.Content;
    }else{
        text = @"More";
        moreItem = YES;
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 2000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    if(label == nil){
        label = (UILabel*) [cell viewWithTag:1];
    }
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    [label setTextAlignment:moreItem ? UITextAlignmentCenter : UITextAlignmentLeft];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = nil;
    if(indexPath.row < _page.data.count){
        QSItem *item = [_page.data objectAtIndex:indexPath.row];
        text = item.Content;
    }else{
        text = @"More";
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 2000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (void) loadData:(QsCategroy) category
    loadNextPage:(BOOL) loadNext{
    _page.listPosition = myTableView.contentOffset;
    [_indicator startAnimating];
    [self.dataMgr getDataWithCategroy:category loadNextPage:loadNext withDelegate:self];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"willSelectRowAtIndexPath");
    NSUInteger category = myTabBar.selectedItem.tag;
    if(category != QSCateGroyBookmark && indexPath.row == self.page.data.count){
        // moreItem pressed
        [self loadData:category loadNextPage:YES];
        return nil;
    }
    [self performSegueWithIdentifier:@"detail" sender:indexPath];
    return nil;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForsegue");
    
    if([[segue identifier] isEqualToString:@"bookmark"]){
        
        return;
    }
    
    
    DetailViewController *detailController = (DetailViewController*) segue.destinationViewController;
    detailController.indexPath = sender;
    
    NSMutableArray *datas = self.page.data;
    detailController.datas = datas;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger category = (NSUInteger)item.tag;
    [self loadData:category loadNextPage:NO];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"begin record offset");
    self.page.listPosition = scrollView.contentOffset;
    NSLog(@"end record offset");

} 


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


}


- (void)dealloc{
    [myTableView release];
    for(int i = 0 ; i < myTabBar.items.count ; i++){
        [[myTabBar.items objectAtIndex:i]release];
    }
    [myTabBar release];
    [_dataMgr release];
    [_indicator release];
    [super dealloc];
}


- (void) didQsDataLoaded:(BOOL)ok data:(QSPage *)data{
    NSLog(@"didQsDataLoaded");
    [_indicator stopAnimating];
    if(!ok){
        // load data failed
        NSLog(@"load data failed");
        return;
    }
    self.page = data;
    
    [self performSelectorOnMainThread:@selector(notifyDataLoaded) withObject:self waitUntilDone:NO];
    }

- (void) notifyDataLoaded{
    [myTableView reloadData];
    [myTableView setContentOffset:self.page.listPosition animated:YES];

}



@end
