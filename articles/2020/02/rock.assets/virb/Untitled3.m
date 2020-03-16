clear all ;
s=load('ag.mat');
ag=s.a4;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;
tg=tg(index)-3;
ag=ag(index);
tg(300:1000)=tg(300):dt:tg(300)+dt*700;
ag(300:1000)=0.01*sin(tg(300:1000));
figure(1)
plot(tg,ag,'black');
hold on
xlim([0,10]);ylim([-0.7,0.7]);grid on;
alpha=0.3;
T=2;
rst=zeros(length(alpha),length(T));
rstv=zeros(length(alpha),length(T));
for i=1:length(alpha)
    disp(alpha(i))
    index=find(ag>tan(alpha),1);
    tg_temp=tg(index:end)-tg(index);
    ag_temp=ag(index:end);
    plot(tg_temp,ag_temp)
    for j=1:length(T)
        [rt,dtheta]=untitled(alpha(i),T(j),tg_temp,ag_temp);
        rstd(i,j)=max(abs(dtheta(:,1)))/alpha(i);
        rstv(i,j)=max(abs(dtheta(:,2)))/(2*pi/T(j));
    end 
end
% 
figure(2)
rstd(rstd>1)=1;
% surf(T,alpha,rstd)
figure(3)
% surf(T,alpha,rstv)

figure(4)
plot(rt,dtheta(:,1),'black');
hold on
plot(rt,dtheta(:,2),'r')
plot(rt(1:end-1),diff(dtheta(:,1))./diff(rt))
% max(abs(dtheta(:,2)))
% (2*pi/T(j))
% hold off;