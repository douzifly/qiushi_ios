//
//  DataStore.h
//  Funny
//
//  Created by 小 元 on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (void) saveData:(NSString *) data;

+ (NSMutableArray *)readData;

@end
