//
//  QSData.m
//  Funny
//
//  Created by douzifly on 13-4-14.
//
//

#import "QSDataMgr.h"
#import "HttpHelper.h"
#import "DataStore.h"

@interface LoadThreadObj : NSObject
@property QsCategroy category;
@property (retain) QSPage* page;
@property (retain) id<QSDataDelegate> delegate;
@end

@implementation LoadThreadObj

-(void)dealloc{
    [self.delegate release];
    [self.page release];
    [super dealloc];
}

@end

@interface QSDataMgr(){
    
}
- (NSMutableArray *)convertString:(NSString *)content;
@end

@implementation QSDataMgr{

}

@synthesize loadThread;

- (NSMutableArray *)convertString:(NSString *)content
{
    NSLog(@"parseContent");
    if(content == nil){
        NSLog(@"content is nil,cant parse");
        return nil;
    }
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<div class=\"content\" title=(.*?)\">(.*?)</div>" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray* matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    NSLog(@"matches retainCount:%d",[matches retainCount]);
    if(matches.count > 0){
        NSLog(@"match count : %d ", matches.count);
        for(NSTextCheckingResult* result in matches){
            NSRange range = NSMakeRange(result.range.location + 49, result.range.length - 49 - 6);
            NSString* strContent = [[content substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(strContent.length > 0){
                QSItem* item = [[[QSItem alloc] init] autorelease];
                item.Content = strContent;
                [array addObject:item];
            }
        }
        NSLog(@"end");
    }else{
        NSLog(@"count is %d",matches.count);
    }
    return array;
}

- (NSString *)getUrlForCategroy:(QsCategroy)categroy{
    if (categroyUrls == nil){
        categroyUrls = [[NSArray alloc] initWithObjects:QSCategroyArray];
    }
    return [categroyUrls objectAtIndex:categroy];
}
- (void) loadDataFromSvr:(LoadThreadObj*) obj{
    NSLog(@"load data from server obj retain count:%d if 1 means i should retain it", [obj retainCount]);
    NSString* url = [[self getUrlForCategroy:obj.category] stringByAppendingFormat:@"%d",(obj.page.pageIndex + 1) ];
    NSString* webcontent = [HttpHelper requestUrl:url withMethod:@"GET"];
    NSLog(@"web content:%@", webcontent);
    if (webcontent == nil){
        if ([obj.delegate respondsToSelector:@selector(didQsDataLoaded:data:)]){
            [obj.delegate didQsDataLoaded:YES data:obj.page];
        }
        return;
    }
    NSMutableArray *data = [self convertString:webcontent];
    [obj.page.data addObjectsFromArray:data];
    obj.page.pageIndex++;
    if ([obj.delegate respondsToSelector:@selector(didQsDataLoaded:data:)]){
        [obj.delegate didQsDataLoaded:YES data:obj.page];
    }
    loadThread = nil;
}

- (void)getDataWithCategroy:(QsCategroy)categroy loadNextPage:(BOOL)nextPage withDelegate:(id<QSDataDelegate>)delegate{
    NSLog(@"getDataWithCategroy category:%d, loadNextPage:%d", categroy, nextPage);
    if (qsData == nil){
        qsData = [[QsDatas alloc]initWithCapacity:10];
    }
    NSString* key = [self getUrlForCategroy:categroy];
    QSPage *page = (QSPage *)[qsData objectForKey:key];
    if(page == nil){
        page = [[[QSPage alloc] init] autorelease];
        [qsData setObject:page forKey:key];
    }
    
    if(page.data != nil && page.data.count > 0 && !nextPage){
        NSLog(@"have old data and do not load nextPage");
        if ([delegate respondsToSelector:@selector(didQsDataLoaded:data:)]){
            [delegate didQsDataLoaded:YES data:page];
        }
        return;
    }
    
    if(categroy == QSCateGroyBookmark){
        // load data from db
        page.data = [DataStore readData];
        if ([delegate respondsToSelector:@selector(didQsDataLoaded:data:)]){
            [delegate didQsDataLoaded:YES data:page];
        }
        return;
    }
    
    if(loadThread != nil){
        NSLog(@"cancel loading thread");
        [loadThread cancel];
        loadThread = nil;
    }
    
    LoadThreadObj* obj = [[[LoadThreadObj alloc] init] autorelease];
    obj.page = page;
    obj.category = categroy;
    obj.delegate = delegate;
    self.loadThread = [[[NSThread alloc] initWithTarget:self selector:@selector(loadDataFromSvr:) object:obj] autorelease];
    [self.loadThread start];
    return;
}


- (void)dealloc
{
    [categroyUrls release];
    [qsData release];
    [loadThread release];
    [super dealloc];
}

@end
