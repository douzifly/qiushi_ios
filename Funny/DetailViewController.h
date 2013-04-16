//
//  DetailViewController.h
//  Funny
//
//  Created by 小 元 on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *btnCopy;
@property (retain, nonatomic) NSIndexPath *indexPath;
@property (retain, nonatomic) NSMutableArray* datas;
- (IBAction)btnClick:(id)sender;
- (IBAction)btnClickOutside:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblContent;
@property (retain, nonatomic) IBOutlet UIButton *btnFavorite;
- (IBAction)btnFavoriteClick:(id)sender;

@end
