//
//  YWIndexPath.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWIndexPath.h"

@interface YWIndexPath ()
@property (nonatomic, assign, readwrite) NSInteger section;
@property (nonatomic, assign, readwrite) NSInteger row;
@property (nonatomic, assign, readwrite) NSInteger item;
@end

@implementation YWIndexPath
+ (instancetype)indexPathForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section{
    YWIndexPath *index = [[YWIndexPath alloc] init];
    index.section = section;
    index.row = row;
    index.item = item;
    return index;
}
+(instancetype)indexPathForItem:(NSInteger)item section:(NSInteger)section{
    YWIndexPath *index = [[YWIndexPath alloc] init];
    index.section = section;
    index.item = item;
    return index;
}
- (void)dealloc{
    NSLog(@"YWIndexPath--%s",__func__);
}
@end
