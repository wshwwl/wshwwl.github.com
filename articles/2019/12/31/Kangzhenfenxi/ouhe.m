clear all;
%% 原始尺寸
li=[415.5,700.5,937.5,1257.5,1459.5,1779.5,308.5,593.5,830.5,1150.5,1450.5,1770.5];
li=li/1000;
h=163/1000;
li2=li.^2+h^2;
n=24;
s=2*sum(li2)/n;

L=4494/1000;
m=3000;
c=1581;
k=500000;
c=c*n;
k=k*n;
I=m*L*L/12;

f1=sqrt(k/m)/2/pi
f2=sqrt(k*s/I)/2/pi

w=1:0.5:200;
f=w/2/pi;
A=-m*w.^2+w*c*j+k;
B=w*c*h*j+k*h;
C=-I*w.^2+w*s*c*j+s*k;
Hrx=m*w.^2./A;
BBAC=B.^2./A./C;
x_u=Hrx./(1-BBAC);
x_u_a=x_u+1;
loglog(f,abs(Hrx+1));
hold on;
loglog(f,abs(x_u_a),'r');
xlim([3,40]);
ylim([0.1,10]);
grid on
legend('没有耦合','耦合');
xlabel('Freq(Hz)');
%% 比例工装
li=[300,300];
li=li/1000;
h=163/1000;
li2=li.^2+h^2;
n=4;
s=2*sum(li2)/n;

L=4494/1000/6;
m=3000/6;
c=1581;
k=500000;
c=c*n;
k=k*n;
I=50;

f1=sqrt(k/m)/2/pi
f2=sqrt(k*s/I)/2/pi

f=w/2/pi;
A=-m*w.^2+w*c*j+k;
B=w*c*h*j+k*h;
C=-I*w.^2+w*s*c*j+s*k;
Hrx=m*w.^2./A;
BBAC=B.^2./A./C;
x_u=Hrx./(1-BBAC);
x_u_a=x_u+1;

loglog(f,abs(Hrx+1));
hold on;
loglog(f,abs(x_u_a),'r');
xlim([3,40]);
ylim([0.1,10]);
grid on
legend('没有耦合','耦合');
xlabel('Freq(Hz)');
%% 
li=[415.5,700.5,937.5,1257.5,1459.5,1779.5,308.5,593.5,830.5,1150.5,1450.5,1770.5];
li2=li.^2;
li2=li2/1000000;
w=sqrt(1000000*sum(li2)/5075.8)
f=w/2/pi





