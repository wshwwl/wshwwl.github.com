function nonlinearrock_sin(alpha,p)

p=2.14; %刚体参数p
alpha=0.25; %刚体参数alpha
ap=2.93*alpha; %三角函数幅值,这里不需要乘以g，因为我在微分方程里已经消除了g。
omega=5*p; %三角函数角速度
tstop=2*pi/omega; %正/余弦输入终止时间
tg=0:0.01:6; %全部计算时长
ag=zeros(1,length(tg)); %初始化输入，全为0；
tsin=0:0.01:tstop; %正、余弦输入的时间段
ag(1:length(tsin))=ap*sin(omega*tsin); %将正、余弦的输入覆盖到初始输入上去
subplot(3,1,1)
plot(tg,ag)

tstart=asin(tan(alpha)/ap)/omega; %开始计算时刻，该时刻输入的幅值满足ap*sin(omega*t)=tan(alpha),如果是余弦，则改时刻为0，所以之前写的是0.
inity=[0,0];
option=odeset('RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
tspan=[tstart,2];
while tspan(1)<tspan(end)
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,tspan,inity,option);
    subplot(3,1,2);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
    subplot(3,1,3);plot(rt_temp,ry_temp(:,2)/p,'r');hold on;
    if isempty(ie)
        break;
    end
    if ie(end)==1
        inity=ye(end,:);
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        tspan=[te(end),tspan(end)];
        if abs(inity(2))<1e-6
            break;
        end
        continue;
    end
    if ie(end)==2
        break;
    end
end

    function dy=wffc(t,y)
        t
        dy=zeros(2,1);
        ag_t=ap*sin(omega*t); %计算当前时刻的加速度,如果是余弦，则改为余弦
        sgn=sign(y(1));
        if sgn==0
            sgn=sign(y(2)); %如果偏转角度为0，则根据角速度判断即将偏转的方向
            if sgn==0
                sgn=-sign(ag_t); %如果偏转角速度也为0，则以地面加速度的方向来判断即将偏转的方向
            end
        end
        dy(1)=y(2);
        if t<=tstop
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
        else
            dy(2)=-p^2*sin(alpha*sgn-y(1));
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


