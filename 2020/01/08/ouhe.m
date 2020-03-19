clearvars;
x=0.3;
h=0.1;
s=x.^2+h^2;

m=500;
c=5000;
k=1800000;
I=55;

w=1:0.5:200;
f=w/2/pi;
A=-m*w.^2+w*c*1i+k;
B=w*c*h*1i+k*h;
C=-I*w.^2+w*s*c*1i+s*k;
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
