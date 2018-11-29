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
    BOOL _setFrame;
    BOOL _showBorder;

    CGFloat _lastOffX;
    CGFloat _defalutWidth;
    CGFloat _titleWidth;

    NSInteger _mode;
    NSInteger _item;
    
    NSString *_notif;
    NSArray *_widthList;
    

}
@end

@implementation YWTableViewHeadView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                              parameter:(NSDictionary *)parameter{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _notif = parameter[@"notification"];
        _defalutWidth = [parameter[@"defalutWidth"] floatValue];
        _mode = [parameter[@"mode"] integerValue];
        _item = [parameter[@"item"] integerValue];
        _showBorder = [parameter[@"showBorder"] boolValue];
        _widthList = parameter[@"itemWidths"];
        [self initUIShowBorderColor:parameter[@"color"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];
    }
    return self;
}
- (void)initUIShowBorderColor:(UIColor *)color{
    
    if (_mode == 0) {
        [self.contentView addSubview:self.nameLabel];
        [self createLabels:_item showBorderColor:color];
    }else{
        [self createLabelsInScrollView:_item showBorderColor:color];
    }
    self.rightScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    [self.contentView addSubview:self.rightScrollView];
    
}
- (void)createLabels:(NSInteger)items
     showBorderColor:(UIColor *)color{
    
    CGSize size = self.contentView.frame.size;
    
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int i = 1; i < items; i ++) {
        CGFloat w = 0;
        if (i < _widthList.count) {
            w = [_widthList[i] floatValue];
        }else{
            w = _defalutWidth;
        }
        UILabel *label1 = [UILabel new];
        label1.frame = CGRectMake(startX, 0, w, size.height);
        label1.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
        startX = startX + w;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        if (_showBorder) {
            label1.layer.borderWidth = 1;
            label1.layer.borderColor = color.CGColor;
        }
        [self.rightScrollView addSubview:label1];
        totalWidth += w;
    }
    self.rightScrollView.contentSize = CGSizeMake(totalWidth, 0);
    
}

- (void)createLabelsInScrollView:(NSInteger)items
                 showBorderColor:(UIColor *)color{
    CGSize size = self.contentView.frame.size;
    
    CGFloat totalWidth = 0;
    CGFloat startX = 0;
    for (int i = 0; i < items; i ++) {
        CGFloat w = 0;
        if (i < _widthList.count) {
            w = [_widthList[i] floatValue];
        }else{
            w = _defalutWidth;
        }
        UILabel *label1 = [UILabel new];
        label1.frame = CGRectMake(startX, 0, w, size.height);
        label1.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
        startX = startX + w;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textAlignment = NSTextAlignmentCenter;
        if (_showBorder) {
            label1.layer.borderWidth = 1;
            label1.layer.borderColor = color.CGColor;
        }
        [self.rightScrollView addSubview:label1];
        totalWidth += w;
    }
    self.rightScrollView.contentSize = CGSizeMake(totalWidth, 0);
    
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleWidth, self.contentView.frame.size.height)];
        _nameLabel.autoresizingMask =  UIViewAutoresizingFlexibleHeight;//高度
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}
- (UIScrollView *)rightScrollView{
    if (!_rightScrollView) {
        _rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _rightScrollView.showsVerticalScrollIndicator = NO;
        _rightScrollView.showsHorizontalScrollIndicator = NO;
        _rightScrollView.delegate = self;
        _rightScrollView.bounces = NO;
    }
    return _rightScrollView;
}

- (void)setLeftname{
    
    if (_widthList.count > 0) {
        _titleWidth = [_widthList.firstObject floatValue];
    }else{
        _titleWidth = _defalutWidth;
    }
    CGSize size = self.contentView.frame.size;
    self.nameLabel.frame = CGRectMake(0, 0, _titleWidth, size.height);
    self.rightScrollView.frame = CGRectMake(_titleWidth, 0, size.width-_titleWidth, size.height);
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
        if (_mode == 0) {
            [self setLeftname];
        }else if (_mode == 1){
            [self setScrollview];
        }
    }
}

@end
