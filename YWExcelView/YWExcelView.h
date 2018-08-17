//
//  YWExcelView.h
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWIndexPath.h"

@class YWExcelView;


typedef NS_ENUM(NSInteger, YWExcelViewStyle) {
    YWExcelViewStyleDefalut = 0,//整体表格滑动，上下、左右均可滑动（除第一列不能左右滑动以及头部View不能上下滑动外）
    YWExcelViewStylePlain,//整体表格滑动，上下、左右均可滑动（除第一行不能上下滑动以及头部View不能上下滑动外）
    YWExcelViewStyleheadPlain,//整体表格(包括头部View)滑动，上下、左右均可滑动（除第一列不能左右滑动外）
    YWExcelViewStyleheadScrollView,//整体表格(包括头部View)滑动，上下、左右均可滑动
};

@protocol YWExcelViewDataSource<NSObject>
@required
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section;
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView;
@optional
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath;
- (void)excelView:(YWExcelView *)excelView headView:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath;
//分组
- (NSInteger)numberOfSectionsInExcelView:(YWExcelView *)excelView;
@end

@protocol YWExcelViewDelegate <NSObject>


@optional

//自定义每列的宽度/默认每列的宽度为80
- (NSArray *)widthForItemOnExcelView:(YWExcelView *)excelView;

@end

@interface YWExcelView : UIView
@property (nonatomic,assign,readonly) YWExcelViewStyle style;
@property (nonatomic,           weak) id <YWExcelViewDelegate>delegate;
@property (nonatomic,           weak) id <YWExcelViewDataSource>dataSource;
//是否显示边框，宽度默认为1
@property (nonatomic,assign,getter=isShowBorder) BOOL showBorder;
@property (nonatomic,strong) UIColor *showBorderColor;
- (instancetype)initWithFrame:(CGRect)frame
                        style:(YWExcelViewStyle)style
                 headViewText:(NSArray *)titles
                       height:(CGFloat)height;
@end
