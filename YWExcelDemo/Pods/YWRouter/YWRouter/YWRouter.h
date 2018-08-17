//
//  YWRouter.h
//  YWRouter
//
//  Created by yaowei on 2018/5/10.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YWRouter : NSObject<NSCopying>
/**
 * 获取全局唯一的对象
 */
+ (instancetype _Nullable )YWRouterSingletonInstance;
/**
 获取某个实体对象 --- 推荐用于~组件之间的通信
 
 @param targetName Target_%@的类名
 @param actionName Target_%@的类里面的action
 @param params 传递参数(可选)
 @param isNeedCacheTarget 是否需要Target_%@的类的对象缓存起来
 @return 实体对象
 */
- (id _Nullable )performTarget:(NSString *_Nullable)targetName
                        action:(NSString *_Nullable)actionName
                        params:(NSDictionary *_Nullable)params
               needCacheTarget:(BOOL)isNeedCacheTarget;

/**
 获取控制器，交互给外界，用当前者决定怎么使用该控制器
 
 @param controllerName 控制器名称
 @param params 参数（可选）
 @return 控制器
 */
- (UIViewController *_Nullable)OpenControllerName:(NSString *_Nullable)controllerName params:(NSDictionary *_Nullable)params;
/**
 获取控制器
 *--格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param ctrUrl url链接
 @return 控制器
 */
- (UIViewController *_Nullable)OpenControllerWithURL:(NSString *_Nullable)ctrUrl;

#pragma mark --------  push控制器 --------

/**
 push控制器（同系统）
 
 @param ctrUrl 链接 --格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param animated 是否动画
 */
+ (void)YW_pushControllerWithURL:(NSString *_Nullable)ctrUrl animated:(BOOL)animated;
/**
 push控制器（同系统）
 
 @param controllerName 目标控制器的类名
 @param params 参数
 @param animated 是否动画
 */
+ (void)YW_pushControllerName:(NSString *_Nullable)controllerName params:(NSDictionary *_Nullable)params animated:(BOOL)animated;
/**
 push控制器
 
 @param ctrUrl 链接
 @param animated 是否需要动画
 */
- (void)pushControllerWithURL:(NSString *_Nullable)ctrUrl animated:(BOOL)animated;



#pragma mark --------  modal控制器 --------
/**
 modal控制器
 
 @param ctrUrl 链接 --格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param animated 是否需要动画
 @param completion 完成回调
 */
+(void)YW_presentViewController:(NSString *_Nullable)ctrUrl animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
/**
 modal控制器
 
 @param controllerName 目标控制器的类名
 @param params 参数（key-value）
 @param animated 动画
 @param completion 完成回调
 */
+(void)YW_presentViewControllerName:(NSString *_Nullable)controllerName params:(NSDictionary *_Nullable)params animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
/**
 modal 控制器（同系统)
 
 @param ctrUrl 链接 --格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param animated 是否需要动画
 @param completion 完成回调
 */
- (void)presentViewController:(NSString *_Nullable)ctrUrl animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;


#pragma mark --------  dismiss控制器 --------
/**
 快捷dismiss一层
 
 @param animated 是否动画
 @param completion 回调
 */
+ (void)YW_dismissViewControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
/**
 dismiss掉几层控制器（类方法）
 
 @param layer 多少层
 @param animated 是否动画
 @param completion 回调
 */
+ (void)YW_dismissViewControllerWithLayer:(NSUInteger)layer Animated:(BOOL)animated completion: (void (^ __nullable)(void))completion;
/**
 dismiss掉到根层控制器
 
 @param animated 是否动画
 @param completion 回调
 */
+ (void)YW_dismissToRootViewControllerWithAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion;

/**
 dismiss掉几层控制器
 
 @param layer 多少层
 @param animated 是否动画
 @param completion 回调
 */
- (void)dismissViewControllerWithLayer:(NSUInteger)layer Animated:(BOOL)animated completion: (void (^ __nullable)(void))completion;


#pragma mark --------  pop控制器 --------
/**
 快捷pop上一个控制器
 
 @param animated 是否动画
 */
+ (void)YW_popViewControllerAnimated:(BOOL)animated;
/**
 pop掉几层控制器（类方法）
 
 @param layer 多少层
 @param animated 是否动画
 */
+ (void)YW_popViewControllerWithLayer:(NSUInteger)layer Animated:(BOOL)animated;
/**
 pop掉到根层控制器
 
 @param animated 是否动画
 */
+ (void)YW_popToRootViewControllerWithAnimated:(BOOL)animated;

/**
 pops掉几层控制器（对象方法）
 
 @param layer 多少层
 @param animated 是否动画
 */
- (void)popViewControllerWithLayer:(NSUInteger)layer Animated:(BOOL)animated;



/**
 获取当前使用的控制器

 @return 返回当前使用的控制器
 */
- (UIViewController*_Nullable)currentViewController;

@end

@interface UIViewController (YWRouter)
//控制器获取传递的参数，通过重写params的set方法，类似Android的bundle传值方式(当@"custom"存在时，即是用户自定义的参数，详见demo-YWModularDetailViewController)
@property (nonatomic, strong) NSDictionary * _Nullable params;
/** 回调block */
@property (nonatomic, strong) void(^ _Nullable ywReturnBlock)(id _Nullable value);

@end
