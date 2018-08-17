//
//  TableViewController.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "TableViewController.h"
#import <YWRouter/YWRouter.h>

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打造iOS的excel表";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [YWRouter YW_pushControllerName:@"YWTestViewController" params:@{@"ctl":_list[indexPath.row]} animated:YES];
    }else if (indexPath.row == 1){
        [YWRouter YW_pushControllerName:@"YWTestViewController2" params:@{@"ctl":_list[indexPath.row]} animated:YES];
    }else if (indexPath.row == 2){
        [YWRouter YW_pushControllerName:@"YWTestViewController3" params:@{@"ctl":_list[indexPath.row]} animated:YES];
    }else if (indexPath.row == 3){
        [YWRouter YW_pushControllerName:@"YWTestViewController4" params:@{@"ctl":_list[indexPath.row]} animated:YES];
        
    }
}

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray arrayWithArray:
                 @[
                   @"头部独立view，第一列不能左右滑动 其他均可上下左右滑动",
                   @"头部独立view，整体均可上下左右滑动,除了第一行不能上下滑动",
                   @"整体表格(包括头部View)滑动，上下、左右均可滑动（除第一列不能左右滑动外)",
                   @"整体表格(包括头部View)滑动，上下、左右均可滑动"
                   ]
                 ];
    }
    return _list;
}

@end
