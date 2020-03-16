%% 与论文结果对比
clear all ;
global tg ag;
tpulse=0:0.01:0.5;
tg=0:0.01:6;
A=0.5545;
ag=zeros(1,length(tg));
ag(1:length(tpulse))=A*sin(2*pi*tpulse);
figure(1)
plot(tg,ag)
grid on
%%
b=0.2;
h=0.6;
R=sqrt(b^2+h^2);
alpha=atan(b/h);
g=9.81;
p=sqrt(3*g/4/R);

[ry]=linearrock2(alpha,p);
figure(2)
subplot(2,1,1)
plot(tg,ry(:,1)/alpha);
subplot(2,1,2)
plot(tg,ry(:,2));