# 向视图中添加菜单
UIMenuController类使得开发者可以向身为第一响应者的任务物体之中添加弹出式菜单。一般来说，菜单是与文本视图及文本框结合起来使用的，它使得用户能够执行选取、拷贝、粘贴等操作。另外，开发者也可通过菜单来提供交互式屏幕元件有关的操作。

本方案演示如何获取共享的UIMenuController，以及如何向其中添加菜单项。开发者需要设置菜单的目标矩形（一般来说，需要传入自己的bounds以及展示菜单的视图），并调整菜单的箭头方向，然后调用菜单的update方法，使我们对菜单所做的修改能够生效。

菜单项也有其标准的目标-动作回调机制，但我们不需要设置目标。目标总是身为第一响应者的视图。