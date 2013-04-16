//
//  QSDataMode.h
//  Funny
//
//  Created by douzifly on 13-4-17.
//
//

#import <Foundation/Foundation.h>

@interface QSItem : NSObject

@property (retain) NSString* Id;
@property (retain) NSString* Content;
@property (retain) NSString* PicUrl;

@end

@interface QSPage : NSObject

@property NSInteger pageIndex;
@property (retain) NSMutableArray *data;
@property CGPoint listPosition;

@end
