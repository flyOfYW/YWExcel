# YWExcel
打造类似excel表的展示控件

采用UITableView和UIScrollView嵌套使用来实现Excel、课程表、上下左右联动效果。

在项目中遇到了许多报表，虽然目前只是一个简单的展示，可以用tableView单元格显示，满足目前的需求，但是我仔细考虑了，能不能实现类似Excel表那样展示，既可以左右滑动，又可以上下滑动，当时找了许多资料，也找了许多国外网站的资料，却找不到这样类似的开源项目，不过后面在code4app发现了UITableViewLinkageDemo 他的github：https://github.com/HawkEleven/UITableViewLinkageDemo 但是仔细研究代码后，发现其内部复用性是个问题同时不能支持上下拉刷新等，后面在github这个demo的作者提了一些我的想法，在接着加Q各自聊了Excel的控件的思路，最终我决定自己去实现一个类似Excel的控件，因此结合UITableViewLinkageDemo的思想，去摸索，最终实现了这样的控件（# YWExcel
）
## 兼容性
1、兼容横屏和竖屏
2、iOS8以上


## 集成方法:

### 1. 把`YWExcel`这个文件夹拖到项目中.

### 2. 使用`cocoapods`:
```ruby
   pod 'YWExcel'
```

#### 效果图
![效果图.gif](https://upload-images.jianshu.io/upload_images/3030124-8e3edbd810124be5.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/410)


### 整体描述图
![图.png](https://upload-images.jianshu.io/upload_images/3030124-24e03180b43919f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/411)

1、红色部分为：UITableView

2 蓝色部分：UITableViewCell

3 黄色部分：UISrollView

4 类目那一行：目前设置2个模式

1）作为独立tableView之上的view

2）作为tableView的组头View

### 设置联动的思路
在 -(void)scrollViewDidScroll:(UIScrollView *)scrollView
监听偏移量，去改变其他scrollView的偏移量（采用通知中心）

#### 类似tableView的用法
```objc
@protocol YWExcelViewDataSource<NSObject>
@required
//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section;
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView;
@optional
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath;
- (void)excelView:(YWExcelView *)excelView headView:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath;
//分组
- (NSInteger)numberOfSectionsInExcelView:(YWExcelView *)excelView;
@end

@protocol YWExcelViewDelegate <NSObject>


@optional

//自定义每列的宽度/默认每列的宽度为80
- (NSArray *)widthForItemOnExcelView:(YWExcelView *)excelView;

@end

```

#### 样式选择
```objc
typedef NS_ENUM(NSInteger, YWExcelViewStyle) {
    YWExcelViewStyleDefalut = 0,//整体表格滑动，上下、左右均可滑动（除第一列不能左右滑动以及头部View不能上下滑动外）
    YWExcelViewStylePlain,//整体表格滑动，上下、左右均可滑动（除第一行不能上下滑动以及头部View不能上下滑动外）
    YWExcelViewStyleheadPlain,//整体表格(包括头部View)滑动，上下、左右均可滑动（除第一列不能左右滑动外）
    YWExcelViewStyleheadScrollView,//整体表格(包括头部View)滑动，上下、左右均可滑动
};

```

