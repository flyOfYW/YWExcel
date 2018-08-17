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
    CGFloat _lastOffX;
    CGFloat _defalutWidth;
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
                    itemCount:(NSInteger)item
               withItemWidths:(NSArray *)itemWidths
             itemDefalutWidth:(NSInteger)width
                   withNotiID:(NSString *)notif
                   showBorder:(BOOL)showBorder
              showBorderColor:(UIColor *)color{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _notif = notif;
        _defalutWidth = width;
        [self initItemWidths:itemWidths itemCount:item showBorder:showBorder showBorderColor:color];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];
        
    }
    return self;
}

- (instancetype)initWithCellInSrcollectionStyle:(UITableViewCellStyle)style
                                reuseIdentifier:(NSString *)reuseIdentifier
                                      itemCount:(NSInteger)item
                                 withItemWidths:(NSArray *)itemWidths
                               itemDefalutWidth:(NSInteger)width
                                     withNotiID:(NSString *)notif
                                     showBorder:(BOOL)showBorder
                                showBorderColor:(UIColor *)color{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _notif = notif;
        _defalutWidth = width;
        [self initCellInSrcollectionItemWidths:itemWidths itemCount:item showBorder:showBorder showBorderColor:color];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:_notif object:nil];
        
    }
    return self;
}

- (void)initCellInSrcollectionItemWidths:(NSArray *)itemWidths
                               itemCount:(NSInteger)items
                              showBorder:(BOOL)showBorder
                         showBorderColor:(UIColor *)color{
    
    CGSize size = self.contentView.frame.size;
    
    CGFloat titleWidth = 0;
    
    if (itemWidths) {
        titleWidth = [itemWidths.firstObject floatValue];
    }else{
        titleWidth = _defalutWidth;
    }
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    scr.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
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
        label1.frame = CGRectMake(startX, 0, w, size.height);
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
    
    CGSize size = self.contentView.frame.size;

    CGFloat titleWidth = 0;
    
    if (itemWidths) {
        titleWidth = [itemWidths.firstObject floatValue];
    }else{
        titleWidth = _defalutWidth;
    }
    
    
    UILabel *labe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, size.height)];
    labe.autoresizingMask =  UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
    labe.textAlignment = NSTextAlignmentCenter;
    labe.font = [UIFont systemFontOfSize:14];
    if (showBorder) {
        labe.layer.borderWidth = 1;
        labe.layer.borderColor = color.CGColor;
    }
    [self.contentView addSubview:labe];
    _nameLabel = labe;
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(titleWidth, 0, size.width-titleWidth, size.height)];
    scr.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自适应宽度|高度
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
        label1.frame = CGRectMake(startX, 0, w, size.height);
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
    NSLog(@"YWExcelCell--%s",__func__);

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
