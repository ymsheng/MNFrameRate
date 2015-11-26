# MNFrameRate
iOS测试FPS的工具 （支持iOS6及以上）

### 在iOS开发时，我们经常要注意屏幕渲染是否卡。通过检测每秒的丢桢数，计算得出FPS.
#### 1、把本工程中的MNFrameRate两个添加到自己的项目中
#### 2、在AppDelegate.m文件引入头文件：#import "MNFrameRate.h"
#### 3、在 -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 的window初始化后，加入 [MNFrameRate sharedFrameRate].enabled = YES; //YES打开FPS，NO关闭FPS
#### 4、如果用mainStoryBoard,建议放到ViewController中的一个事件触发。
####  5、Demo在iOS7的iphone4s上测试比iOS9的iphone5s渲染速度快。
