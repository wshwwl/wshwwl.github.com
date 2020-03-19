fs1=100; %����Ƶ��
dt1=1/fs1;
T=10;   %ʱ��
t1=0:dt1:T-dt1;
ddy1=rand(1,fs1*T)-0.5; %ʱ��
ddy1(1)=0;
fs2=500;
dt2=1/fs2;
t2=0:dt2:T-dt2;
ddy2=interp1(t1,ddy1,t2); %��ֵ��ʱ��
h=0.02; %�����
freqs=logspace(log10(0.1),log10(100),100);
accResponse1=sdof_response(h,50,dt1,ddy1);
accResponse2=sdof_response(h,50,dt2,ddy2);
accResponse3=sdof_response(h,1,dt1,ddy1);
accResponse4=sdof_response(h,1,dt2,ddy2);
accResponse5=sdof_response(h,100,dt1,ddy1);
accResponse6=sdof_response(h,100,dt2,ddy2);
accResponseSpectrum1=tts(h,freqs,ddy1,dt1);
accResponseSpectrum2=tts(h,freqs,ddy2,dt2);

figure(1)
subplot(3,1,1)
plot(t1,accResponse3,'o-',t2,accResponse4,'*-r');
xlim([1 1.05]);
xlabel('ʱ��(s)');
ylabel('���ٶȣ�1Hz��');
grid on;
subplot(3,1,2);
plot(t1,accResponse1,'o-',t2,accResponse2,'*-r');
xlim([1 1.05]);
xlabel('ʱ��(s)');
ylabel('���ٶȣ�50Hz��');
grid on;
subplot(3,1,3)
plot(t1,accResponse5,'o-',t2,accResponse6,'*-r');
xlim([1 1.05]);
xlabel('ʱ��(s)');
ylabel('���ٶȣ�100Hz����');
grid on;
figure(2)
plot(freqs,accResponseSpectrum1,freqs,accResponseSpectrum2,'r');
xlabel('Ƶ��(Hz)');
ylabel('���ٶȷ�Ӧ��ֵ');
grid on
figure(3)
plot(t1,ddy1,'o-',t2,ddy2,'*-');
xlim([1 1.05]);
xlabel('ʱ��(s)');
ylabel('���ٶ�');
grid on;

