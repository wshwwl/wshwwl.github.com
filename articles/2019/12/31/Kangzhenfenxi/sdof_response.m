function [acc,vel,dis]=sdof_response(h,f,dt,ddy)

if f*20>1/dt
   time1=0:dt:length(ddy)*dt-dt;
   dt=1/f/20;
   time2=0:dt:max(time1);
   ddy=interp1(time1,ddy,time2);
end

n_sample=length(ddy);
acc=zeros(1,n_sample);
vel=zeros(1,n_sample);
dis=zeros(1,n_sample);

w=2*pi*f;
w2=w*w;
hw=h*w;
wd=w*sqrt(1-h*h);
wdt=wd*dt;
E=exp(-hw*dt);
cwdt=cos(wdt);
swdt=sin(wdt);
a11=E*(cwdt+hw*swdt/wd);
a12=E*swdt/wd;
a21=-E*w2*swdt/wd;
a22=E*(cwdt-hw*swdt/wd);

s1=2*h/w2/w/dt;
s2=(1-2*h*h)/w2/wdt;
s3=1/w2/dt;
s4=h/w/wdt;
b11=E*((1/w2+s1)*cwdt+(h/w/wd-s2)*swdt)-s1;
b12=E*(-s1*cwdt+s2*swdt)-1/w2+s1;
b21=E*(-s3*cwdt-(s4+1/wd)*swdt)+s3;
b22=E*(s3*cwdt+s4*swdt)-s3;

acc(1)=2*hw*ddy(1)*dt;
vel(1)=-ddy(1)*dt;
dis(1)=0;

for i=2:n_sample
    dis(i)=a11*dis(i-1)+a12*vel(i-1)+b11*ddy(i-1)+b12*ddy(i);
    vel(i)=a21*dis(i-1)+a22*vel(i-1)+b21*ddy(i-1)+b22*ddy(i);
    acc(i)=-2*hw*vel(i)-w2*dis(i);
end
% toc
% time=dt:dt:n_sample*dt;
% tic
% sys=tf(-1,[1,2*hw,w2]);
% dis2=lsim(sys,ddy,time);
% toc

