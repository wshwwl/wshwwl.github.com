function linearrock()
b=0.5;
h=1.5;
ap=0.55435;
R=sqrt(b^2+h^2);
alpha=atan(b/h);
g=9.81;
p=sqrt(3*g/4/R);
option=odeset('RelTol',1e-10,'AbsTol',1e-12,'Events',@EventFcn);

omega=2*pi;
t=asin(alpha/ap)/omega;
tspan=[t,2];
inity=[0,0];
[rt,ry,te,ye,ie]=ode45(@wffc,tspan,inity,option);
figure(1)
subplot(2,1,1)
plot(rt,ry(:,1)/alpha);
subplot(2,1,2)
plot(rt,ry(:,2));

    function dy=wffc(t,y)
        dy=zeros(2,1);
        dy(1)=y(2);
        if t<=0.5
            dy(2)=p^2*y(1)-(p^2)*ap*sin(omega*t)+alpha*p^2;
        else
            dy(2)=p^2*y(1)+alpha*p^2;
        end
    end

    function [value,isterminal,direction]=EventFcn(~,y)
        value(1)=y(1);
        isterminal(1)=1;
        direction(1)=0;
        
        value(2)=abs(y(1))-alpha;
        isterminal(2)=1;
        direction(2)=1;
    end
end


