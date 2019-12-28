function [max_acc]=max_sdof_acc_response(h,f,dt,ddy)

n_sample=length(ddy);
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

max_acc=0;
vel=0;
predis=0;

for i=2:n_sample
    dis=a11*predis+a12*vel+b11*ddy(i-1)+b12*ddy(i);
    vel=a21*predis+a22*vel+b21*ddy(i-1)+b22*ddy(i);
    acc=abs(2*hw*vel+w2*dis);
    predis=dis;
    if acc>max_acc
        max_acc=acc;
    end
end


