
# RUC追课

RUC追课是2015年上架AppStore帮助人民大学同学找寻课堂小伙伴的 iOS App

### 缘起

2013年的时候，我发现人民大学原校内网数字人大上，所有同学的登记照都是以学号为路径存储的，遂全部爬取了下来。
2015年9月新学期伊始，我照惯例爬取了所有人民大学新生入学的登记照。这时候，品园二楼132宿舍的猥琐四君子其他三君子也发现了我的照片集，于是在我电脑上看了一圈，只为了评选这一年级最漂亮的登记照。
他们很快就统一给出了答案。接下来的一周都念念不忘。
念念不忘必有回想，他们就向我提出了进一步的问题：知道了最美丽的登记照，怎么才能认识TA呢？
实力宠室友的我，决定趁选课结果刚出，花了一个周末的时间，为他们做一个基于课程的社交软件。

### 功能

在RUC追课上，你可以通过姓名或者学号，将感兴趣的同学加入关注。然后你关注的同学的课程活动将会按时间顺序展示在你的时间线上。你还可以访问同学的RUC追课主页给TA留言。

|登录界面|添加关注人|某同学的主页|时间线|时间点详情|
|:-:|:-:|:-:|:-:|:-:|
|![登录界面](https://github.com/limitMe/ruc-class-follower-ios/blob/master/screenshots/P1.jpg)|![添加关注人](https://github.com/limitMe/ruc-class-follower-ios/blob/master/screenshots/P4.jpg)|![某同学的主页](https://github.com/limitMe/ruc-class-follower-ios/blob/master/screenshots/P2.jpg)|![时间线](https://github.com/limitMe/ruc-class-follower-ios/blob/master/screenshots/P5.jpg)|![时间点详情](https://github.com/limitMe/ruc-class-follower-ios/blob/master/screenshots/P3.jpg)|

### 架构

ruc-class-follower-iOS 是采用Objective-C编写的RUC追课的iOS客户端，也是唯一的客户端。
ruc-class-follower-service 是采用C#编写的Aspx .Net 4.5服务端。
ruc-class-catcher 是采用C#编写的.Net 4.5控制台应用，人大校内网暴露了通过学生uuid查询当前学生课程，通过课程id查询该班级学生，通过从我自己的uuid开始，不花几层就能爬取完全校学生当前选课信息。

### 缘灭

虽然这个App被提交到App Store，但因为爬虫本身带有的隐私风险，我并没有宣传这个App。2016年2月春季学期开学后我用爬虫重新更新课程信息后没有再次更新。RUC追课事实上自此废弃。