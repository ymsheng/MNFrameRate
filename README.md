# MNFrameRate
iOS测试FPS的工具

### 在iOS开发时，我们经常要注意屏幕渲染是否卡。通过检测每秒的丢桢数，计算得出FPS.
#### 1、把本工程中的MNFrameRate两个添加到自己的项目中
#### 2、在AppDelegate.m文件引入头文件：#import "MNFrameRate.h"
#### 3、在 -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 的window初始化后，加入 [MNFrameRate sharedFrameRate].enabled = YES; //YES打开FPS，NO关闭FPS
#### 4、如果用mainStoryBoard,建议放到ViewController中的一个事件触发。
