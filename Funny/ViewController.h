//
//  ViewController.h
//  Funny
//
//  Created by 小 元 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "QSDataMgr.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, QSDataDelegate>

@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) IBOutlet UITabBar *myTabBar;
@property (nonatomic,retain) QSDataMgr *dataMgr;
@property (nonatomic,retain) QSPage    *page;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;

@end

