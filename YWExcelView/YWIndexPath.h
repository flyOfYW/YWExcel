//
//  YWIndexPath.h
//  YWExcelDemo
//
//  Created by yaowei on 2018/8/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWIndexPath : NSObject
@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger item;

+(instancetype)indexPathForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;
+(instancetype)indexPathForItem:(NSInteger)item section:(NSInteger)section;

@end
