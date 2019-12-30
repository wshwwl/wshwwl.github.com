clear all;
tao=83/1000;
am=2.2;
dt=tao/100;
t=0:dt:tao;
T=0:dt:tao*100;
aut=am*sin(pi/tao*t);
Aut=zeros(size(T));
Aut(1:length(aut))=aut;

[acc,vel,dis]=sdof_response(0.054,10,dt,Aut);

f=8:0.1:12;
h=0.05;
rf=tts2(h,f,Aut,dt);
plot(f,rf,'black','linewidth',2)
xlabel('频率/(Hz)');
ylabel('加速度幅值/(g）');
grid on

