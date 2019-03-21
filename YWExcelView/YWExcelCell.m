//
//  YWExcelCell.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWExcelCell.h"

@interface YWExcelCell ()
<UIScrollViewDelegate>
{
    UILabel *_titleLabel;
    
    BOOL _isAllowedNotification;
    BOOL _showBorder;
    
    CGFloat _lastOffX;
    CGFloat _defalutWidth;
    CGFloat _titleWidth;
    
    NSInteger _mode;
    NSInteger _item;
    NSString *_notif;
    
}
@end

@implementation YWExcelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    parameter:(NSDictionary *)parameter{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _notif = parameter[@"notification"];
        _defalutWidth = [parameter[@"defalutWidth"] floatValue];
        _mode = [parameter[@"mode"] integerValue];
        _item = [parameter[@"item"] integerValue];
        _showBorder = [parameter[@"showBorder"] boolValue];
        [self initUIWidths:parameter[@"itemWidths"] showBorderColor:parameter[@"color"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];
        
    }
    return self;
}
- (void)initUIWidths:(NSArray *)itemWidths
     showBorderColor:(UIColor *)color{
    
    CGSize size = self.contentView.frame.size;

    if (itemWidths && itemWidths.count > 0) {
        _titleWidth = [itemWidths.firstObject floatValue];
    }else{
        _titleWidth = _defalutWidth;
    }
    if (_mode == 0) {
        [self.contentView addSubview:self.nameLabel];
        if (_showBorder) {
            self.nameLabel.layer.borderWidth = 1;
            self.nameLabel.layer.borderColor = color.CGColor;
        }
        self.rightScrollView.frame = CGRectMake(_titleWidth, 0, size.width-_titleWidth, size.height);
        [self createLabels:_item widths:itemWidths showBorderColor:color];

    }else if (_mode == 1){
           self.rightScrollView.frame = CGRectMake(0, 0, size.width, size.height);
        [self createLabelsInScrollView:_item widths:itemWidths showBorderColor:color];
    }
    self.rightScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    [self.contentView addSubview:self.rightScrollView];
    
}
- (void)createLabels:(NSInteger)items
              widths:(NSArray *)itemWidths
     showBorderColor:(UIColor *)color{
    
    CGSize size = self.contentView.frame.size;

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
              widths:(NSArray *)itemWidths
     showBorderColor:(UIColor *)color{
    
    CGSize size = self.contentView.frame.size;
    
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;//
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isAllowedNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isAllowedNotification) {//是自身才发通知去tableView以及其他的cell
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:_notif object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isAllowedNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isAllowedNotification = YES;
        if (_lastOffX != x) {
            [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        _lastOffX = x;
    }else{
        _isAllowedNotification = NO;
    }
    obj = nil;
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_notif object:nil];
}
//多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
