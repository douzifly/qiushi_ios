//
//  HttpHelper.m
//  Funny
//
//  Created by 小 元 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper
+ (NSString *)requestUrl:(NSString *)url withMethod:(NSString *)method
{
    NSLog(@"request url is %@",url);
    NSURL *nsUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:nsUrl];
    [request setHTTPMethod:method];
    NSHTTPURLResponse *rsp ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&rsp error:nil];
    if(data == nil){
        NSLog(@"data is nil");
    }else{
        //NSLog(@"data is %s",[data bytes]);
    }
    NSString *ret = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [request release];
    return ret;
}

@end
