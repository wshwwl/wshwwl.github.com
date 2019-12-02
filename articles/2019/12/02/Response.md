#　反应谱求解

## 参考书籍

接触反应谱主要源于力学分析工作中的谱分析，主要是抗震分析。

我的有关于反应谱和地震相关的学习主要参考书籍**《地震动的谱分析入门》**，作者为日本的**大崎顺彦**，写的非常好。

![](book.jpg)

这本书里面给出了地震动加速度激励下线性单质点弹簧阻尼系统的响应的求解方法和Fortran代码，用的是线性加速度法，是一种直接积分法。

## 线性加速度法

设质点对地面的相对位移为$x$，固有频率为$\omega$，阻尼为$h$，地震加速度时间历程为$\ddot{y}(t)$，则系统的运动方程可表示为：
$$
\ddot{x}+2h\omega\dot{x}+{\omega}^2x=-\ddot{y}(t)\qquad(a)
$$
设$\ddot{y}(t)$是按一定的时间间隔$\Delta t$，在每个时刻$t_1$,$t_2$,...$t_i$...以离散值$\ddot{y}_1$,$\ddot{y}_2$,...$\ddot{y}_i$...给出的，则当把$\ddot{y}_i$和$\ddot{y}_{i+1}$之间以直线内插，设$t_i$为区间$t_i$~$t_{i+1}$的原点，$\tau$为该区间的局部时间，$\Delta\ddot{y}=\ddot{y}_{i+1}-\ddot{y}_i$时，可把$\ddot{y}(t)$表示为：
$$
\ddot{y}(t)=\frac{\Delta\ddot{y}}{\Delta t}+\ddot{y}_t
$$
在该区间内公式1成为：
$$
\ddot{x}(\tau)+2h\omega\dot{x}(\tau)+\omega^2x(\tau)=-\frac{\Delta\ddot{y}}{\Delta t}\tau+\ddot{y}\qquad 0\le\tau\le\Delta t
$$

解该非齐次方程，当给定区间在开始时刻$t_i$的初始时刻初始条件为
$$
\tau=0,x=x_i,\dot{x}=\dot{x}_i
$$
在区间终点$\tau=\Delta t$，即在时刻$t_{i+1}=t_i+\Delta t$时的相对位移及相对速度为：
$$
x_{i+1}=A_{11}x_i+A_{12}\dot{x}_i+B_{11}\ddot{y}_i+B_{12}\ddot{y}_{i+1}\qquad\quad\\
 
\dot x_{i+1}=A_{21}x_i+A_{22}\dot{x}_i+B_{21}\ddot{y}_i+B_{22}\ddot{y}_{i+1}\qquad(b)
$$
其中：
$$
A_{11}=e^{-h\omega \Delta t}(cos\omega_d\Delta t+\frac{h\omega}{\omega_d}sin\omega_d\Delta t)
$$

$$
A_{12}=e^{-h\omega \Delta t}\frac{1}{\omega_d}sin\omega_d\Delta t
$$

$$
A_{21}=-e^{-h\omega \Delta t}\frac{\omega^2}{\omega_d}sin\omega_d\Delta t
$$

$$
A_{22}=e^{-h\omega \Delta t}(cos\omega_d\Delta t-\frac{h\omega}{\omega_d}sin\omega_d\Delta t)
$$

$$
B_{11}=e^{-h\omega \Delta t}[(\frac{1}{\omega^2}+\frac{2h}{\omega^3\Delta t})cos\omega_d\Delta t+(\frac{h}{\omega\omega_d}-\frac{1-2h^2}{\omega^2\omega_d\Delta t})sin\omega_d\Delta t]-\frac{2h}{\omega^3\Delta t}
$$

$$
B_{12}=e^{-h\omega \Delta t}[-\frac{2h}{\omega^3\Delta t}cos\omega_d\Delta t+\frac{1-2h^2}{\omega^2\omega_d\Delta t}sin\omega_d\Delta t]-\frac 1{\omega^2}+\frac{2h}{\omega^3\Delta t}
$$

$$
B_{21}=
$$

