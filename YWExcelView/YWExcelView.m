//
//  YWExcelView.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWExcelView.h"
#import "YWExcelCell.h"
#import "YWTableViewHeadView.h"



@interface YWExcelView ()
<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_list;
    
}
@property (nonatomic, assign,getter=isSettingFrame) BOOL settingFrame;

@property (nonatomic,assign,readwrite) YWExcelViewStyle style;

@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, assign) CGFloat cellLastX;
@property (nonatomic, assign) CGFloat defalutWidth;

@property (nonatomic, strong) YWExcelCell *excelCell;
@property (nonatomic, strong) UITableView *tableView;



//YWExcelViewStyleDefalut
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic,   copy) NSArray *headtexts;

//通知-name
@property (nonatomic, strong, readwrite) NSString *NotificationID;

//优化获取每列的宽度(只获取一遍)
@property (nonatomic,   copy) NSArray *itemWidths;
@property (nonatomic, assign) NSInteger itemCount;


@end

@implementation YWExcelView
//MARK: --- public
- (instancetype)initWithFrame:(CGRect)frame mode:(YWExcelViewMode *)mode{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetingInMode:mode];
    }
    return self;
}
- (void)reloadData{
    [_tableView reloadData];
}
//MARK: -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self getSection];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getRowInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_style == YWExcelViewStyleDefalut) {
        return [self getDefalutCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (_style == YWExcelViewStylePlain){
        return [self getPlainCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (_style == YWExcelViewStyleheadPlain){
        return [self getDefalutCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (_style == YWExcelViewStyleheadScrollView){
        return [self getPlainCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_style == YWExcelViewStyleheadPlain) {
        return [self getStyleheadPlainExcelView:tableView viewForHeaderInSection:section];
    }else if (_style == YWExcelViewStyleheadScrollView){
        return [self getStyleheadScrollViewExcelView:tableView viewForHeaderInSection:section];
    }
    return nil;
}
//MARK: --- privated
- (void)initSetingInMode:(YWExcelViewMode *)mode{
    _headHeight = mode.defalutHeight;
    _style = mode.style;
    _defalutWidth = 80;
    _list = @[].mutableCopy;
    _itemWidths = @[];
    _headtexts = mode.headTexts;
    //以当前对象的指针地址为通知的名称，这样可以避免同一个界面，有多个YWExcelView的对象时，引起的通知混乱
    _NotificationID = [NSString stringWithFormat:@"%p",self];
    _showBorderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    switch (_style) {
        case YWExcelViewStyleDefalut:
            [self initStyleWithDefalut];
            break;
        case YWExcelViewStylePlain:
            [self initStyleWithDefalut];
            break;
        case YWExcelViewStyleheadPlain:
            [self initStyleWithHeadPlain];
            break;
        case YWExcelViewStyleheadScrollView:
            [self initStyleWithHeadPlain];
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_NotificationID object:nil];
}
- (YWTableViewHeadView *)getStyleheadPlainExcelView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YWTableViewHeadView *headView = (YWTableViewHeadView *)[tableView dequeueReusableCellWithIdentifier:@"headView"];
    if (!headView) {
        headView = [[YWTableViewHeadView alloc] initWithReuseIdentifier:@"headView" parameter:@{@"item":@([self item]),@"itemWidths":[self itemWidth],@"defalutWidth":@(_defalutWidth),@"notification":_NotificationID,@"showBorder":@(self.isShowBorder),@"color":self.showBorderColor,@"mode":@"0"}];
    }
    YWIndexPath *index = [YWIndexPath indexPathForItem:0 section:section];
    [_dataSource excelView:self headView:headView.nameLabel textAtIndexPath:index];
    index = nil;
    int i = 1;
    for (UILabel *label in headView.rightScrollView.subviews) {
        YWIndexPath *indexPathCell = [YWIndexPath indexPathForItem:i section:section];
        [_dataSource excelView:self headView:label textAtIndexPath:indexPathCell];
        indexPathCell = nil;
        i++;
    }
    return headView;
}
- (YWTableViewHeadView *)getStyleheadScrollViewExcelView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  YWTableViewHeadView *headView = (YWTableViewHeadView *)[tableView dequeueReusableCellWithIdentifier:@"headScrollectionView"];
    if (!headView) {
        headView = [[YWTableViewHeadView alloc] initWithReuseIdentifier:@"headView" parameter:@{@"item":@([self item]),@"itemWidths":[self itemWidth],@"defalutWidth":@(_defalutWidth),@"notification":_NotificationID,@"showBorder":@(self.isShowBorder),@"color":self.showBorderColor,@"mode":@"1"}];
    }
    int i = 0;
    for (UILabel *label in headView.rightScrollView.subviews) {
        YWIndexPath *indexPathCell = [YWIndexPath indexPathForItem:i section:section];
        [_dataSource excelView:self headView:label textAtIndexPath:indexPathCell];
        indexPathCell = nil;
        i++;
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_style == YWExcelViewStyleheadPlain) {
        return _headHeight;
    }else if (_style == YWExcelViewStyleheadScrollView) {
        return _headHeight;
    }
    return 0.001;
}

- (YWExcelCell *)getPlainCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];
    if (!cell) {
        cell = [[YWExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"plainCell" parameter:@{@"item":@([self item]),@"itemWidths":[self itemWidth],@"defalutWidth":@(_defalutWidth),@"notification":_NotificationID,@"showBorder":@(self.isShowBorder),@"color":self.showBorderColor,@"mode":@"1"}];
    }
    int i = 0;
    for (UILabel *label in cell.rightScrollView.subviews) {
        YWIndexPath *indexPathCell = [YWIndexPath indexPathForItem:i row:indexPath.row section:0];
        [_dataSource excelView:self label:label textAtIndexPath:indexPathCell];
        indexPathCell = nil;
        i++;
    }
    _excelCell = cell;
    return cell;
}

- (YWExcelCell *)getDefalutCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"plainCell" parameter:@{@"item":@([self item]),@"itemWidths":[self itemWidth],@"defalutWidth":@(_defalutWidth),@"notification":_NotificationID,@"showBorder":@(self.isShowBorder),@"color":self.showBorderColor,@"mode":@"0"}];
    }
    YWIndexPath *index = [YWIndexPath indexPathForItem:0 row:indexPath.row section:0];
    [_dataSource excelView:self label:cell.nameLabel textAtIndexPath:index];
    index = nil;
    int i = 1;
    for (UILabel *label in cell.rightScrollView.subviews) {
        YWIndexPath *indexPathCell = [YWIndexPath indexPathForItem:i row:indexPath.row section:0];
        cell.indexPath = index;
        [_dataSource excelView:self label:label textAtIndexPath:indexPathCell];
        indexPathCell = nil;
        i++;
    }
    _excelCell = cell;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectIsEmpty(self.frame)&& !_settingFrame) {
        switch (_style) {
            case YWExcelViewStyleDefalut:
                [self layoutStyleWithDefalut];
                break;
            case YWExcelViewStylePlain:
                [self layoutStyleWithDefalut];
                break;
            case YWExcelViewStyleheadPlain:
                [self layoutStyleWithHeadPlain];
                break;
            case YWExcelViewStyleheadScrollView:
                [self layoutStyleWithHeadPlain];
                break;
            default:
                break;
        }
    }
    
}
//MARK: --- _delegate

- (NSInteger)getSection{
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfSectionsInExcelView:)]) {
        return [_dataSource numberOfSectionsInExcelView:self];
    }
    return 1;
}
- (NSInteger)getRowInSection:(NSInteger)section{
    if (_dataSource && [_dataSource respondsToSelector:@selector(excelView:numberOfRowsInSection:)]) {
        return [_dataSource excelView:self numberOfRowsInSection:section];
    }
    return 0;
}
- (NSInteger)item{
    
    if (_itemCount != 0) {
        return _itemCount;
    }
    _itemCount = [_dataSource itemOfRow:self];
    
    return _itemCount;
}
- (NSArray *)itemWidth{
    
    if (_itemWidths.count > 0) {
        return _itemWidths;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(widthForItemOnExcelView:)]) {
        _itemWidths = [_delegate widthForItemOnExcelView:self];
    }
    return _itemWidths;
}

- (void)setShowBorder:(BOOL)showBorder{
    _showBorder = showBorder;
    if (showBorder) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = _showBorderColor.CGColor;
    }else{
        self.layer.borderWidth = 0;
    }
}

//MARK: --- UI

- (void)initStyleWithDefalut{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headV = [UIView new];
    [self addSubview:headV];
    _headView = headV;
    _tableView.rowHeight = _headHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
}
- (void)initStyleWithHeadPlain{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = _headHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


- (void)layoutStyleWithDefalut{
    
    CGFloat w = CGRectGetWidth(self.frame);
    _headView.frame = CGRectMake(0, 0, w, _headHeight);
    _headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.frame = CGRectMake(0, _headHeight, w, CGRectGetHeight(self.frame) - _headHeight);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (_style == YWExcelViewStylePlain) {
        [self creatHeadViewPlayin];
    }else{
        [self creatHeadView];
    }
    _settingFrame = YES;
}

- (void)layoutStyleWithHeadPlain{
    CGFloat w = CGRectGetWidth(self.frame);
    _tableView.frame = CGRectMake(0, 0, w, CGRectGetHeight(self.frame) );
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _settingFrame = YES;
}
- (void)creatHeadView{
    
    NSInteger count = [self item];
    NSArray *arr = [self itemWidth];
    
    CGFloat lblW = arr.count > 0 ? [[arr firstObject] floatValue] : _defalutWidth;
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.frame = CGRectMake(0, 0, lblW, _headHeight);
    if (_headtexts && _headtexts.firstObject) {
        titleLbl.text = _headtexts.firstObject;
    }
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:titleLbl];
    
    if (self.isShowBorder) {
        titleLbl.layer.borderWidth = 1;
        titleLbl.layer.borderColor = _showBorderColor.CGColor;
    }
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lblW, 0, self.frame.size.width-lblW, _headHeight)];
    self.topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int  i = 1; i < count; i ++) {
        UILabel *label = [UILabel new];
        if (i < arr.count ) {
            CGFloat sW = [arr[i] floatValue];
            label.frame = CGRectMake(startX, 0, sW, _headHeight);
            startX = sW + startX;
            totalWidth += sW;
        }else{
            label.frame = CGRectMake(startX, 0, _defalutWidth, _headHeight);
            startX = _defalutWidth + startX;
            totalWidth += _defalutWidth;
        }
        if (i < _headtexts.count) {
            label.text = _headtexts[i];
        }
        if (self.isShowBorder) {
            label.layer.borderWidth = 1;
            label.layer.borderColor = _showBorderColor.CGColor;
        }
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.topScrollView addSubview:label];
    }
    self.topScrollView.contentSize = CGSizeMake(totalWidth, 0);
    self.topScrollView.delegate = self;
    self.topScrollView.bounces = NO;
    [_headView addSubview:self.topScrollView];
    [_list addObject:self.topScrollView];
}

- (void)creatHeadViewPlayin{
    NSInteger count = [self item];
    NSArray *arr = [self itemWidth];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _headHeight)];
    self.topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int  i = 0; i < count; i ++) {
        UILabel *label = [UILabel new];
        if (i < arr.count ) {
            CGFloat sW = [arr[i] floatValue];
            label.frame = CGRectMake(startX, 0, sW, _headHeight);
            startX = sW + startX;
            totalWidth += sW;
        }else{
            label.frame = CGRectMake(startX, 0, _defalutWidth, _headHeight);
            startX = _defalutWidth + startX;
            totalWidth += _defalutWidth;
        }
        if (i < _headtexts.count) {
            label.text = _headtexts[i];
        }
        if (self.isShowBorder) {
            label.layer.borderWidth = 1;
            label.layer.borderColor = _showBorderColor.CGColor;
        }
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.topScrollView addSubview:label];
    }
    self.topScrollView.contentSize = CGSizeMake(totalWidth, 0);
    self.topScrollView.delegate = self;
    self.topScrollView.bounces = NO;
    [_headView addSubview:self.topScrollView];
    [_list addObject:self.topScrollView];
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator{
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    _tableView.showsVerticalScrollIndicator = self.isShowsVerticalScrollIndicator;
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([_list containsObject:scrollView]) {
        //判断为headView滚动，改变cell内部的rightScrollView的偏移量
        CGPoint offSet = _excelCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        //_excelCell使用改变量的因为方便，只要一个cell滑动，便触发通知
        _excelCell.rightScrollView.contentOffset = offSet;
        for (UIScrollView *bg in _list) {
            if (![bg isEqual:scrollView]) {
                bg.contentOffset = offSet;
            }
        }
    }
    if ([scrollView isEqual:self.tableView]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:_NotificationID object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
    
}
-(void)scrollMove:(NSNotification*)notification{
    
    NSDictionary *noticeInfo = notification.userInfo;
    float x = [noticeInfo[@"cellOffX"] floatValue];
//    NSLog(@"view收到===%f",x);
    if (self.cellLastX != x) {//避免重复设置偏移量
        self.cellLastX = x;
        if (self.topScrollView) {
            CGPoint offSet = self.topScrollView.contentOffset;
            offSet.x = x;
            self.topScrollView.contentOffset = offSet;
        }

    }
    
    noticeInfo = nil;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_NotificationID object:nil];    
}
//MARK: --- 旧版弃用的方法
- (instancetype)initWithFrame:(CGRect)frame
                        style:(YWExcelViewStyle)style
                 headViewText:(NSArray *)titles
                       height:(CGFloat)height{
    self = [super initWithFrame:frame];
    if (self) {
        _headHeight = height;
        _style = style;
        _defalutWidth = 80;
        _list = @[].mutableCopy;
        _itemWidths = @[];
        _headtexts = titles;
        //以当前对象的指针地址为通知的名称，这样可以避免同一个界面，有多个YWExcelView的对象时，引起的通知混乱
        _NotificationID = [NSString stringWithFormat:@"%p",self];
        _showBorderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        switch (style) {
            case YWExcelViewStyleDefalut:
                [self initStyleWithDefalut];
                break;
            case YWExcelViewStylePlain:
                [self initStyleWithDefalut];
                break;
            case YWExcelViewStyleheadPlain:
                [self initStyleWithHeadPlain];
                break;
            case YWExcelViewStyleheadScrollView:
                [self initStyleWithHeadPlain];
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_NotificationID object:nil];
        
    }
    return self;
}
@end
