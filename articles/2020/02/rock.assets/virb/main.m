%% el波
% clear all ;
% s=load('ag.mat');
% global tg ag;
% ag=s.a4;
% dt=0.025;
% tg=0:dt:dt*length(ag)-dt;
% index=tg>=3&tg<=13;
% tg=tg(index)-3;
% ag=ag(index);
%% 地震波2
clear all;
load('rsn982.mat');
global tg ag;
ag=s.a1;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=1&tg<=11;
tg=tg(index)-1;
ag=ag(index);
%%
figure(2)
subplot(2,2,1);
plot(tg,ag)
grid on
title('Earth quake')
%% 求解
dalpha=0.1;
dT=2;
alpha=0.1:dalpha:0.3;
T=1:dT:8;
p=2*pi./T;
g=9.81;
sd=zeros(length(alpha),length(T));
sv=zeros(length(alpha),length(T));
su=zeros(length(alpha),length(T));
tic
for i=1:length(alpha)
    i
     for j=1:length(T)
        ry=rock(alpha(i),T(j));
        rmax=max(abs(ry));
        sd(i,j)=rmax(1)/alpha(i);
        sv(i,j)=rmax(2)/p(j);
        su(i,j)=3*g*(T(j)^2)*(sin(alpha(i))-sin(alpha(i)-rmax(1)))/8/pi/pi;
    end
end
figure(2)
subplot(2,2,2)
surf(T,alpha,sd)
title('theta/alpha-alpha-T')
figure(2)
subplot(2,2,3)
surf(T,alpha,sv)
title('theta''/p-alpha-T')
zlim([0,1])
figure(2)
subplot(2,2,4)
surf(T,alpha,su)
colormap(flipud(colormap))
title('u-alpha-T')
%% 积分
rsi=0;
for i=1:length(alpha)-1
    for j=1:length(T)-1
        rsi=rsi+dalpha*dT*(sd(i,j)+sd(i+1,j)+sd(i,j+1)+sd(i+1,j+1))/4;
    end
end
rvi=0;
for i=1:length(alpha)-1
    for j=1:length(T)-1
        rvi=rvi+dalpha*dT*(sv(i,j)+sv(i+1,j)+sv(i,j+1)+sv(i+1,j+1))/4;
    end
end
rdi=0;
for i=1:length(alpha)-1
    for j=1:length(T)-1
        rdi=rdi+dalpha*dT*(su(i,j)+su(i+1,j)+su(i,j+1)+su(i+1,j+1))/4;
    end
end
