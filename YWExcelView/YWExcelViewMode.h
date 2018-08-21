//
//  YWExcelViewMode.h
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/21.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YWExcelViewStyle) {
    YWExcelViewStyleDefalut = 0,//整体表格滑动，上下、左右均可滑动（除第一列不能左右滑动以及头部View不能上下滑动外）
    YWExcelViewStylePlain,//整体表格滑动，上下、左右均可滑动（除第一行不能上下滑动以及头部View不能上下滑动外）
    YWExcelViewStyleheadPlain,//整体表格(包括头部View)滑动，上下、左右均可滑动（除第一列不能左右滑动外）
    YWExcelViewStyleheadScrollView,//整体表格(包括头部View)滑动，上下、左右均可滑动
};
@interface YWExcelViewMode : NSObject
//模式
@property (nonatomic,assign) YWExcelViewStyle style;
//默认头部的高度
@property (nonatomic,assign) float defalutHeight;
//头部view的text集合
@property (nonatomic,  copy) NSArray *headTexts;


@end
