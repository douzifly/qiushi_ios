//
//  QSDataMode.m
//  Funny
//
//  Created by douzifly on 13-4-17.
//
//

#import "QSDataModel.h"
@implementation QSPage

@synthesize pageIndex;
@synthesize data = _data;

- (id)init
{
    self = [super init];
    if (self) {
        self.pageIndex = 0;
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    self.data = nil;
    [super dealloc];
}

@end

@implementation QSItem

@synthesize Id;
@synthesize PicUrl;
@synthesize Content;

-(void)dealloc{
    self.Id = nil;
    self.Content = nil;
    self.PicUrl = nil;
    [super dealloc];
}

@end


