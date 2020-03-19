function linearrock2(alpha,p)
p=2.14; %刚体参数p
alpha=0.25; %刚体参数alpha
ap=2.9*alpha; %三角函数幅值,这里不需要乘以g，因为我在微分方程里已经消除了g。
omega=5*p; %三角函数角速度
tstop=2*pi/omega; %正/余弦输入终止时间

tstart=asin(alpha/ap)/omega;
inity=[0,0];
    
option=odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
tspan=[tstart,6];
while tspan(1)<6
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,tspan,inity,option);
    subplot(2,1,1);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
    subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'r');hold on;
    if isempty(ie)
        break;
    end
    if ie(end)==1
        inity=ye(end,:);
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        tspan=[te(end),6];
        continue;
    end
    if ie(end)==2
        break;
    end
end

    function dy=wffc(t,y)
        t
        dy=zeros(2,1);
        sgn=sign(y(1));
        dy(1)=y(2);
        if t<=tstop
            dy(2)=p^2*y(1)-(p^2)*ap*sin(omega*t)-alpha*sgn*p^2;
        else
            dy(2)=p^2*y(1)-alpha*sgn*p^2;
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


