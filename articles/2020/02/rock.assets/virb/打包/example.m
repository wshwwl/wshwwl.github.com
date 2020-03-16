%% 单组计算例子
ag=a1;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;                 %前面这一段可以不用管，这是我调整地震波的过程
tg=tg(index)-3;                     %地震的时间列
ag=ag(index);                       %地震的加速度幅值列
figure(1)
subplot(4,1,1)
plot(tg,ag,'black'); hold off;               %绘制地震波，论文第一个地震波

alpha=0.2;                          %刚体参数alpha
T=2;                                %刚体参数T
[rt,rtheta]=rock1(alpha,T,tg,ag);   %调用rock1函数求解，输入地震波和刚体参数求解
subplot(4,1,2)
plot(rt,rtheta(:,1)/alpha,'black') ;hold off; %绘制theta/alpha-t 
subplot(4,1,3)
plot(rt,rtheta(:,2),'black') ;hod off;       %绘制theta'-t
subplot(4,1,4)
ru=3*9.81*(T^2)*(sin(alpha*sign(rtheta(:,1)))-sin(alpha*sign(rtheta(:,1))-rtheta(:,1)))/8/pi/pi;
plot(rt,ru,'black');hold off;
%% 多组 求解响应谱例子
ag=a1;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=1&tg<=11;                 %前面这一段可以不用管，这是我调整地震波的过程
%%%%%%%%%%
tg=tg(index)-1;                     %地震的时间列
ag=ag(index);                       %地震的加速度幅值列
figure(1)
subplot(2,2,1)
plot(tg,ag,'black');                %绘制地震波，论文第二个地震波
title('Earth quake')

%%%%%%%%%%
dalpha=0.005;
dT=0.2;
alpha=0.1:dalpha:0.3;               %alpha数组，间隔为dtheta
T=1:dT:8;                           %T数组，间隔为dT
[sr,sv,su,rri,rvi,rui]=rock3(alpha,T,tg,ag);     %求解这些参数下的最大响应sr/sv,su,和这三个积分rri/rvi/rui
%%%%%%%%%%
figure(1)
subplot(2,2,2)
surf(T,alpha,sr)                    %绘制theta/alpha-alpha-T
title('theta/alpha-alpha-T')
subplot(2,2,3)
surf(T,alpha,sv)
title('theta''/p-alpha-T')          %绘制theta'/p-alpha-T
zlim([0,1])
subplot(2,2,4)
surf(T,alpha,su)                    %绘制u-alpha-T
colormap(flipud(colormap))
title('u-alpha-T')              
%%%