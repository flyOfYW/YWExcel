//
//  YWExcelCell.h
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWIndexPath.h"



@interface YWExcelCell : UITableViewCell

@property (nonatomic, strong) UIScrollView *rightScrollView;

@property (nonatomic, strong) YWIndexPath *indexPath;

@property (nonatomic, strong) UILabel *nameLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    parameter:(NSDictionary *)parameter;

@end
