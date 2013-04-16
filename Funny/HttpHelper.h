//
//  HttpHelper.h
//  Funny
//
//  Created by 小 元 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject
+ (NSString*) requestUrl:(NSString*) url
             withMethod:(NSString*) method;

@end
