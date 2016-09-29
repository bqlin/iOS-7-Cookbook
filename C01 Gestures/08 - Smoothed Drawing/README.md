# 令绘制效果变得平滑

## 说明

触摸事件的采样率通常受限于CPU的能力。我们可以在点之间进行插值（interpolating），用平滑算法来缓解这些限制。

Catmull-Rom 样条插值法（Catmull-Rom spline）可以在关键点之间创建连续的曲线。运算好的路径能够保持原始路径的形状，而开发者则可以决定在每一对参考点之间插入多少个中间点。我们应该在算法的计算量和所能达到的平滑度之间进行权衡。加入的点越多，CPU资源消耗就越大。

Catmull-Rom 算法每次使用四个点计算第二点和第三点之间的中间值，而开发者可以通过 granularity 参数来指定两个点之间应该插入多少个中间点。

> Erica Sadun 所著的《iOS Drawing： Practical UIKit Solutions》 一书中还讲了很多与 getPointsFromBezier 相似的 UIBezierPath 工具。
网站：<www.graphicsgems.org>，查看《Graphics Gems》系列图书，其中也讲了很多先进的平滑算法。