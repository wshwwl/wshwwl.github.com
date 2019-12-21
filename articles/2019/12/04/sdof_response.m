function [acc,vel,dis]=sdof_response(h,f,dt,ddy)
% 
% if f*20>1/dt
%    time1=0:dt:length(ddy)*dt-dt;
%    dt=1/f/20;
%    time2=0:dt:max(time1);
%    ddy=interp1(time1,ddy,time2);
% end

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

ss=-hw*swdt-wd*cwdt;
cc=-hw*cwdt+wd*swdt;
s1=(E*ss+wd)/w2;
c1=(E*cc+hw)/w2;
s2=(E*dt*ss+hw*s1+wd*c1)/w2;
c2=(E*dt*cc+hw*c1-wd*s1)/w2;
s3=dt*s1-s2;
c3=dt*c1-c2;
b11=-s2/wdt;
b12=-s3/wdt;
b21=(hw*s2-wd*c2)/wdt;
b22=(hw*s3-wd*c3)/wdt;

acc(1)=0;
vel(1)=0;
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

