function [ry]=rock(alpha,T)
global tg ag;
p=2*pi/T;
index=find(abs(ag)>tan(alpha),1);
    sgn=sign(ag(index));
    if index==1
        tgtrig=tg(1);
        index=2;
    else
        tgtrig=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));
    end
    
option=odeset('MaxStep',0.025,'RelTol',1e-8,'AbsTol',1e-10,'Events',@EventFcn);
ry=zeros(length(tg),2);
inity=[0,0];
%% 求解
tstart=tgtrig;
while tstart<tg(end)
    [rt_temp,ry_temp,te,ye,ie]=ode45(@wffc,[tstart,tg(index)],inity,option);
%     subplot(2,1,1);plot(rt_temp,ry_temp(:,1)/alpha,'black');hold on;
%     subplot(2,1,2);plot(rt_temp,ry_temp(:,2),'r');hold on;
    ry(index,:)=max([ry(index,:);abs(ry_temp)]);
    if rt_temp(end)==tg(index)
        inity=ry_temp(end,:);
        tstart=tg(index);
        index=index+1;
        continue;
    end
    if ie(end)==1
        inity=ye(end,:);
        inity(2)=inity(2)*(1-1.5*(sin(alpha))^2);
        tstart=te(end);
        if abs(inity(2))<1e-6
            inity=[0,0];
            nextIndex=find(abs(ag(index:end))>tan(alpha),1);
            if ~isempty(nextIndex)
                index=index+nextIndex-1;
                sgn=sign(ag(index));
                tstart=interp1([ag(index-1),ag(index)],[tg(index-1),tg(index)],sgn*tan(alpha));  
            else
                break;
            end
        end
        continue;
    end
    if ie==2
        break;
    end
end

%% 微分方程
    function dy=wffc(t,y)
        dy=zeros(2,1);
        ag_t=interp1(tg,ag,t,'linear'); %根据线性插值，获取对应时间的地震加速度值
        %微分方程组
        if (abs(y(1))==0)&&(abs(y(2))==0)&&(abs(ag_t)<tan(alpha))
            dy(1)=0;
            dy(2)=0;
        else
            sgn=sign(y(1));
            dy(1)=y(2);
            dy(2)=-p^2*(sin(alpha*sgn-y(1))+ag_t*cos(alpha*sgn-y(1)));
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


