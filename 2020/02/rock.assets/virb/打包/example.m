%% �����������
ag=a1;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=3&tg<=13;                 %ǰ����һ�ο��Բ��ùܣ������ҵ������𲨵Ĺ���
tg=tg(index)-3;                     %�����ʱ����
ag=ag(index);                       %����ļ��ٶȷ�ֵ��
figure(1)
subplot(4,1,1)
plot(tg,ag,'black'); hold off;               %���Ƶ��𲨣����ĵ�һ������

alpha=0.2;                          %�������alpha
T=2;                                %�������T
[rt,rtheta]=rock1(alpha,T,tg,ag);   %����rock1������⣬������𲨺͸���������
subplot(4,1,2)
plot(rt,rtheta(:,1)/alpha,'black') ;hold off; %����theta/alpha-t 
subplot(4,1,3)
plot(rt,rtheta(:,2),'black') ;hod off;       %����theta'-t
subplot(4,1,4)
ru=3*9.81*(T^2)*(sin(alpha*sign(rtheta(:,1)))-sin(alpha*sign(rtheta(:,1))-rtheta(:,1)))/8/pi/pi;
plot(rt,ru,'black');hold off;
%% ���� �����Ӧ������
ag=a1;
dt=0.025;
tg=0:dt:dt*length(ag)-dt;
index=tg>=1&tg<=11;                 %ǰ����һ�ο��Բ��ùܣ������ҵ������𲨵Ĺ���
%%%%%%%%%%
tg=tg(index)-1;                     %�����ʱ����
ag=ag(index);                       %����ļ��ٶȷ�ֵ��
figure(1)
subplot(2,2,1)
plot(tg,ag,'black');                %���Ƶ��𲨣����ĵڶ�������
title('Earth quake')

%%%%%%%%%%
dalpha=0.005;
dT=0.2;
alpha=0.1:dalpha:0.3;               %alpha���飬���Ϊdtheta
T=1:dT:8;                           %T���飬���ΪdT
[sr,sv,su,rri,rvi,rui]=rock3(alpha,T,tg,ag);     %�����Щ�����µ������Ӧsr/sv,su,������������rri/rvi/rui
%%%%%%%%%%
figure(1)
subplot(2,2,2)
surf(T,alpha,sr)                    %����theta/alpha-alpha-T
title('theta/alpha-alpha-T')
subplot(2,2,3)
surf(T,alpha,sv)
title('theta''/p-alpha-T')          %����theta'/p-alpha-T
zlim([0,1])
subplot(2,2,4)
surf(T,alpha,su)                    %����u-alpha-T
colormap(flipud(colormap))
title('u-alpha-T')              
%%%