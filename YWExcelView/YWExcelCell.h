//
//  YWExcelCell.h
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YWExcelCell : UITableViewCell

@property (nonatomic, strong) UIScrollView *rightScrollView;

@property (nonatomic, strong) UILabel *nameLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    parameter:(NSDictionary *)parameter;

//- (instancetype)initWithStyle:(UITableViewCellStyle)style
//              reuseIdentifier:(NSString *)reuseIdentifier
//                    itemCount:(NSInteger)item
//               withItemWidths:(NSArray *)itemWidths
//             itemDefalutWidth:(NSInteger)width
//                   withNotiID:(NSString *)notif
//                   showBorder:(BOOL)showBorder
//              showBorderColor:(UIColor *)color;
//- (instancetype)initWithCellInSrcollectionStyle:(UITableViewCellStyle)style
//                                reuseIdentifier:(NSString *)reuseIdentifier
//                                      itemCount:(NSInteger)item
//                                 withItemWidths:(NSArray *)itemWidths
//                               itemDefalutWidth:(NSInteger)width
//                                     withNotiID:(NSString *)notif
//                                     showBorder:(BOOL)showBorder
//                                showBorderColor:(UIColor *)color;
@end
