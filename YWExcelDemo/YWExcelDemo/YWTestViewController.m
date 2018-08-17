//
//  YWTestViewController.m
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTestViewController.h"
#import <YWRouter/YWRouter.h>
#import "YWExcelView.h"

@interface YWTestViewController ()
<YWExcelViewDataSource>
{
    NSString *_ctl;
    NSMutableArray *_list;
}
@end

@implementation YWTestViewController

- (void)setParams:(NSDictionary *)params{
    [super setParams:params];
    _ctl = params[@"ctl"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _list = @[].mutableCopy;
    
    [_list addObject:@{@"grade":@"年级",@"score":@[@"10",@"20",@"30",@"40",@"50",@"60",@"70"]}];
    [_list addObject:@{@"grade":@"年级",@"score":@[@"101",@"201",@"301",@"401",@"501",@"601",@"701"]}];
    [_list addObject:@{@"grade":@"年级",@"score":@[@"102",@"202",@"302",@"402",@"502",@"602",@"702"]}];
    [_list addObject:@{@"grade":@"年级",@"score":@[@"103",@"203",@"303",@"403",@"503",@"603",@"703"]}];
    [_list addObject:@{@"grade":@"年级",@"score":@[@"104",@"204",@"304",@"404",@"504",@"604",@"704"]}];

    [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];
    [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];
    [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];

    [self test1];
    
    
}
- (void)test1{
    
    YWExcelView *exceView = [[YWExcelView alloc] initWithFrame:CGRectMake(20, 74, CGRectGetWidth(self.view.frame) - 40, 250) style:YWExcelViewStyleDefalut headViewText:@[@"类目",@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"] height:40];
    exceView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    exceView.dataSource = self;
    exceView.showBorder = YES;
    [self.view addSubview:exceView];
    
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(exceView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 20)];
    menuLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    menuLabel.textColor = [UIColor redColor];
    menuLabel.font = [UIFont systemFontOfSize:13];
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.text = _ctl;
    [self.view addSubview:menuLabel];
    
}

//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return 8;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    if (indexPath.row < _list.count) {
        NSDictionary *dict = _list[indexPath.row];
        if (indexPath.item == 0) {
            label.text = dict[@"grade"];
        }else{
            NSArray *values = dict[@"score"];
            label.text = values[indexPath.item - 1];
        }
    }
}
- (void)dealloc{
    NSLog(@"YWTestViewController--%s",__func__);
}
@end
