clear all;
tau=11/1000;
am=10;
dt=tau/100;
t=0:dt:tau;
T=0:dt:tau*100;
at=am*sin(pi/tau*t);
At=zeros(size(T));
At(1:length(at))=at;

f=logspace(log10(1),log10(1000),100);
h=[0.05,0.1,0.5];
for i=1:length(h)
   rf=tts2(h(i),f,At,dt);
   semilogx(f,rf);
   hold on
end
xlabel('频率/(Hz)');
ylabel('加速度幅值/(g）');
grid on
legend('\zeta='+string(h));

