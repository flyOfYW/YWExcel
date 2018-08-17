# YWExcel
打造类似excel表的展示控件

采用UITableView和UIScrollView嵌套使用来实现Excel、课程表、上下左右联动效果。

在项目中遇到了许多报表，虽然目前只是一个简单的展示，可以用tableView单元格显示，满足目前的需求，但是我仔细考虑了，能不能实现类似Excel表那样展示，既可以左右滑动，又可以上下滑动，当时找了许多资料，也找了许多国外网站的资料，却找不到这样类似的开源项目，不过后面在code4app发现了UITableViewLinkageDemo（github：https://github.com/HawkEleven/UITableViewLinkageDemo），
，但是仔细研究代码后，发现其内部复用性是个问题同时不能支持上下拉刷新等，后面在github这个demo的作者提了一些我的想法，在接着加Q各自聊了Excel的控件的思路，最终我决定自己去实现一个类似Excel的控件，因此结合UITableViewLinkageDemo的思想，去摸索，最终实现了这样的控件（# YWExcel
）

### 整体描述图
(https://upload-images.jianshu.io/upload_images/3030124-24e03180b43919f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/411)
