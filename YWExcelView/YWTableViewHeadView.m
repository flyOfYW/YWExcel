//
//  YWTableViewHeadView.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTableViewHeadView.h"

@interface YWTableViewHeadView ()
<UIScrollViewDelegate>
{
    BOOL _isNotification;
    CGFloat _lastOffX;
    CGFloat _defalutWidth;
    NSString *_notif;
    BOOL _setFrame;
    NSInteger _type;
    NSArray *_widthList;
}
@end

@implementation YWTableViewHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                              itemCount:(NSInteger)item
                         withItemWidths:(NSArray *)itemWidths
                       itemDefalutWidth:(NSInteger)width
                             withNotiID:(NSString *)notif
                             showBorder:(BOOL)showBorder
                        showBorderColor:(UIColor *)color{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        _defalutWidth = width;
        _notif = notif;
        _type = 1;
        _widthList = itemWidths;
        [self initItemWidths:itemWidths itemCount:item showBorder:showBorder showBorderColor:color];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];

    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                inSrcollectionitemCount:(NSInteger)item
                         withItemWidths:(NSArray *)itemWidths
                       itemDefalutWidth:(NSInteger)width
                             withNotiID:(NSString *)notif
                             showBorder:(BOOL)showBorder
                        showBorderColor:(UIColor *)color{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        _defalutWidth = width;
        _notif = notif;
        _type = 2;
        _widthList = itemWidths;
        [self initItemWidths:itemWidths inSrcollectionitemCount:item showBorder:showBorder showBorderColor:color];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];
        
    }
    return self;
}
- (void)initItemWidths:(NSArray *)itemWidths
inSrcollectionitemCount:(NSInteger)items
            showBorder:(BOOL)showBorder
       showBorderColor:(UIColor *)color{
    
    CGFloat titleWidth = 0;
    
    if (itemWidths) {
        titleWidth = [itemWidths.firstObject floatValue];
    }else{
        titleWidth = _defalutWidth;
    }
    

    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    scr.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    _rightScrollView = scr;
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int i = 0; i < items; i ++) {
        CGFloat w = 0;
        if (i < itemWidths.count) {
            w = [itemWidths[i] floatValue];
        }else{
            w = _defalutWidth;
        }
        UILabel *label1 = [UILabel new];
        label1.frame = CGRectMake(startX, 0, w, CGRectGetHeight(self.contentView.frame));
        label1.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
        startX = startX + w;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        if (showBorder) {
            label1.layer.borderWidth = 1;
            label1.layer.borderColor = color.CGColor;
        }
        [_rightScrollView addSubview:label1];
        totalWidth += w;
    }
    _rightScrollView.showsVerticalScrollIndicator = NO;
    _rightScrollView.showsHorizontalScrollIndicator = NO;
    _rightScrollView.contentSize = CGSizeMake(totalWidth, 0);
    _rightScrollView.delegate = self;
    _rightScrollView.bounces = NO;
    [self.contentView addSubview:_rightScrollView];
    
}
- (void)initItemWidths:(NSArray *)itemWidths
             itemCount:(NSInteger)items
            showBorder:(BOOL)showBorder
       showBorderColor:(UIColor *)color{
    
    CGFloat titleWidth = 0;
    
    if (itemWidths) {
        titleWidth = [itemWidths.firstObject floatValue];
    }else{
        titleWidth = _defalutWidth;
    }
    
    
    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectZero];

    labe.autoresizingMask =  UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    labe.textAlignment = NSTextAlignmentCenter;
    labe.font = [UIFont systemFontOfSize:14];
    if (showBorder) {
        labe.layer.borderWidth = 1;
        labe.layer.borderColor = color.CGColor;
    }
    [self.contentView addSubview:labe];
    _nameLabel = labe;
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectZero];

    scr.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    _rightScrollView = scr;
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int i = 1; i < items; i ++) {
        CGFloat w = 0;
        if (i < itemWidths.count) {
            w = [itemWidths[i] floatValue];
        }else{
            w = _defalutWidth;
        }
        UILabel *label1 = [UILabel new];
        label1.frame = CGRectMake(startX, 0, w, CGRectGetHeight(self.contentView.frame));
        label1.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
        startX = startX + w;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        if (showBorder) {
            label1.layer.borderWidth = 1;
            label1.layer.borderColor = color.CGColor;
        }
        [_rightScrollView addSubview:label1];
        totalWidth += w;
    }
    _rightScrollView.showsVerticalScrollIndicator = NO;
    _rightScrollView.showsHorizontalScrollIndicator = NO;
    _rightScrollView.contentSize = CGSizeMake(totalWidth, 0);
    _rightScrollView.delegate = self;
    _rightScrollView.bounces = NO;
    [self.contentView addSubview:_rightScrollView];
    
}
- (void)setLeftname{
    CGFloat titleWidth = 0;
    
    if (_widthList) {
        titleWidth = [_widthList.firstObject floatValue];
    }else{
        titleWidth = _defalutWidth;
    }
    CGSize size = self.contentView.frame.size;
    self.nameLabel.frame = CGRectMake(0, 0, titleWidth, size.height);
   self.rightScrollView.frame = CGRectMake(titleWidth, 0, size.width-titleWidth, size.height);
    _setFrame = YES;
}
- (void)setScrollview{
    CGSize size = self.contentView.frame.size;
    self.rightScrollView.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;//
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isNotification) {//是自身才发通知去tableView以及其他的cell
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:_notif object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x),@"tableViewHeadView":@1}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        if (_lastOffX != x) {
            [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        _lastOffX = x;
    }else{
        _isNotification = NO;
    }
    obj = nil;
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_notif object:nil];
    NSLog(@"YWTableViewHeadView--%s",__func__);

}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectIsEmpty(self.contentView.frame) && !_setFrame) {
        if (_type == 1) {
            [self setLeftname];
        }else if (_type == 2){
            [self setScrollview];
        }
    }
}

@end
