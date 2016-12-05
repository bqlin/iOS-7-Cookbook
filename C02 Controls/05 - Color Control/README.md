#编写 UIControl 子类

该范例创建了一种简单的颜色选择器。用户可以触摸该控件，或在控件内部拖拽，以选取颜色。当用户手指在屏幕上左右移动使，颜色的色相（hue）会改便；而上下移动时，其饱和度（saturation）则会变化。颜色的亮度与不透明度固定为 100%。

## 创建控件

创建控件一般分为4步：

1. 继承 UIControl；
2. 在初始化方法中安排好控件的样貌；
3. 编写一些方法追踪并拦截触摸事件；
4. 产生相关事件及视觉反馈效果。

## 追踪触摸事件

UIControl 实例有自己一套对触摸事件的方法。这些方法可以永凯追踪用户操作控件对象的全过程。

- `beginTrachingWithTouch:withEvent:`
	- 如果控件范围内发生了触摸事件，那么系统会调用该方法
- `continueTrackingWithTouch:withEvent:`
	- 如果相关触摸事件仍然在控件范围内持续，那么系统会反复调用该方法
- `endTrackingWithTouch:withEvent:`
	- 该方法用于处理事件结束前的最后一次触摸
- `cancelTrackingWithEvent:`
	- 该方法用于处理触摸操作遭到取消的情况


## 派发控件事件

控件使用 目标 - 动作 组合来传达由事件所引发的变化。

调用 `sendActionForControlEvents:` 方法即可以为自定义控件添加事件派发功能。该方法可以把某个事件发送给控件的目标。控件是通过向 UIApplication 单例发消息来实现这一操作的。UIApplication 对象时所有消息的集中派发点。