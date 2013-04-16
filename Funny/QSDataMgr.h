//
//  QSData.h
//  Funny
//
//  Created by douzifly on 13-4-14.
//
//

#import <Foundation/Foundation.h>
#import "QSDataModel.h"


typedef NSMutableDictionary QsDatas; // contain key:QSCategroyArray str, value:QSPage
typedef NSUInteger QsCategroy;

enum  {
    QSCategroy8HR       = 0,
    QSCategroyNew       = 1,
    QSCategroyHot       = 2,
    QSCateGroyCross     = 3,
    QSCateGroyBookmark  = 4
};

#define QSCategroyArray @"http://www.qiushibaike.com/8hr/page/",@"http://www.qiushibaike.com/late/page/",@"http://www.qiushibaike.com/hot/page/",@"http://www.qiushibaike.com/history/page/", @"bookmark", nil

@protocol QSDataDelegate <NSObject>

- (void) didQsDataLoaded:(BOOL) ok data:(QSPage *) data;

@end

@interface QSDataMgr : NSObject{
    QsDatas *qsData;
    NSArray *categroyUrls;
}

@property (retain) NSThread *loadThread;

- (void) getDataWithCategroy:(QsCategroy) categroy
                    loadNextPage:(BOOL)nextPage
                    withDelegate:(id<QSDataDelegate>) delegate;

- (NSString *) getUrlForCategroy:(QsCategroy) categroy;

@end
